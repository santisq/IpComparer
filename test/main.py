import subprocess
import json

cmd = '''
    Get-PnpDevice -PresentOnly |
        Where-Object { $_.InstanceId -match '^USB' } |
            ConvertTo-Json
'''

result = json.loads(
    subprocess.run(["powershell", "-Command", cmd], capture_output=True).stdout
)

padding = 0
properties = []

for i in result[0].keys():
    if i in ['CimClass', 'CimInstanceProperties', 'CimSystemProperties']:
        continue
    properties.append(i)
    if len(i) > padding:
        padding = len(i)

for i in result:
    print(i)
