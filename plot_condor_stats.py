import  re, subprocess,os, io
import matplotlib.pyplot as plt
os.chdir('E:/TZR/Epistasis/logs')

# val = subprocess.check_call('log_summary.sh %s' %file, shell=True, stdout=out, stderr=subprocess.STDOUT)
#
# print(val)

file = 'time'
dict = {}
with open('%s.txt' % file,'r') as f:
	text = ''.join(f.readlines())
	print(text)
	key_list = re.findall('(?<=epistasis_test_)\d+\.*?', text)
	key_list = [int(x) for x in key_list]
	times = re.findall('(\d+\.\d+)', text)
	times = [float(i) for i in times]
	dict.update(zip(key_list, times))

print(dict)
import collections
odict = collections.OrderedDict(sorted(dict.items()))
plt.bar(range(len(odict)), odict.values(), align='center')
plt.xticks(range(len(odict)), odict.keys())
plt.xlabel('groupSize')
plt.ylabel('time (mins)')
plt.title('time vs groupSize')
plt.show()