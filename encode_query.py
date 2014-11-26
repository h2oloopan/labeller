def read_win(s):
	return s.decode("gbk").encode("utf8")

def write_win(s):
	return s.decode("utf8").encode("gbk","replace")

import urllib
s = read_win(raw_input("answer:"))
s = urllib.quote(s)
s2 = read_win(raw_input("question:"))
s2 = urllib.quote(s2)

import urllib2
command = "http://m160.cs.uwaterloo.ca/solrquery.php?host=m160-6&port=8964&shards=m160-5:8964/solr,m160-6:8964/solr,m160-7:8964/solr,m160-9:8964/solr,m160-10:8964/solr&q="
if s!="":
	command = command + "answercontent_tokenized_0:\"" + s + "\"+AND+"
command = command + "questiontitle_tokenized:\""+s2+"\""
command = command + "&fl=questiontitle_original&rows=200"
result = urllib2.urlopen(command).read()

import json
jres = json.loads(result)
#print write_win(result)
for i in jres["response"]["docs"]:
	print i["questiontitle_original"].encode("gbk","replace")