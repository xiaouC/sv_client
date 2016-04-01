#!/usr/bin/env python
# coding=utf-8

import json
import urllib
from jinja2 import Template

channels = {
    'SDK_UC':  '1800012160275517000120492045032602011016000120490000000000', # 4   UC联运-安卓
    'SDK_360': '1800012160275517000120552046032602011016000120550000000000', # 4   UC联运-安卓
}

#url = 'http://mp.ourpalm.com:9080/newBillingcentreTest/jsp/allconsumecode.jsp?businessid=2718'
url = 'http://p.isa2.cn/newBillingcentre/jsp/allconsumecode.jsp?businessid=2755'
tpl = '''
-- 掌趣支付相关参数
-- 渠道 id
ourpalm_payment_channels = {
    {%- for channelName, channelId in channels.items() %}
    {{ channelName }} = {chanId="{{ channelId }}"},
    {%- endfor %}
}

-- 渠道对应道具 id
ourpalm_payment_properties = {
    {%- for channelName, channelId in channels.items() %}
    {{ channelName }} = {
        {%- set properties = data[channelId[10:32]] -%}
        {%- for item in properties %}
        {amount = "{{ (item.price|int / 100)|int }}", id = "{{ item.consumecodeid }}"},
        {%- endfor %}
    }{% if not loop.last %},{% endif %}
    {%- endfor %}
}
'''

def main():
    req = urllib.urlopen(url)
    data = json.loads(req.read())
    template = Template(unicode(tpl, 'utf8'))
    source = template.render(data=data, channels=channels)
    with open('../config/payment.lua', 'w') as fp:
        fp.write(source.encode('utf8'))

if __name__ == '__main__':
    main()
