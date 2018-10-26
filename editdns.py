import argparse
from pprint import pprint
import SoftLayer

parser = argparse.ArgumentParser()
parser.add_argument('user')
parser.add_argument('apikey')
parser.add_argument('--endpoint')
parser.add_argument('domain', help = 'Example: ruimo.com')
parser.add_argument('hostname', help = 'Example: www')
parser.add_argument('acme_token', help = 'Acme token to be set as a DNS TXT record.')
args = parser.parse_args()

USER = args.user
API_KEY = args.apikey
DOMAIN_NAME = args.domain
HOST_NAME = args.hostname
END_POINT = args.endpoint or 'https://api.softlayer.com/xmlrpc/v3.1/'
ACME_TOKEN = args.acme_token

client = SoftLayer.create_client_from_env(username = USER, api_key = API_KEY, endpoint_url = END_POINT, timeout = 240)
mgr = SoftLayer.managers.dns.DNSManager(client)
zones = mgr.list_zones()
print("Zones:")
pprint(zones)

zone_id = next(filter(lambda e: e['name'] == DOMAIN_NAME, zones))['id']
zone = mgr.get_zone(zone_id)['resourceRecords']
print("Zone:")
pprint(zone)

# Search for existing acme records.
acme_recs = filter(lambda e: e['host'] == ('_acme-challenge.%s' % HOST_NAME), zone)
print("Existing acme records:")
print(acme_recs)

# Remove existing acme records.
for ar in acme_recs:
    mgr.delete_record(ar['id'])

# Create new acme record.
mgr.create_record(zone_id, ('_acme-challenge.%s' % HOST_NAME), 'TXT', ACME_TOKEN)
