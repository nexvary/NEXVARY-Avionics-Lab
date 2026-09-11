#!/usr/bin/env python3
import json, sys
p=sys.argv[1]
with open(p,'r',encoding='utf-8') as f:d=json.load(f)
assert d['schema']=='nexvary-avionics-release-manifest/v1'
assert d['product']=='NEXVARY Avionics Lab'
assert d['version']=='3.2.0'
assert d['stage']==1720
assert d['scope']=='training-simulation-only'
assert len(d['dependencies'])>=4
for dep in d['dependencies']:
    assert dep['name'] and dep['version'] and dep['license'] and dep['source']
print('Stage 1720 release manifest verified')
