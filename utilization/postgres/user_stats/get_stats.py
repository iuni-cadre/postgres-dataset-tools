import pandas as pd

# obtain the dataset contain unix last command results
months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']
last = pd.read_csv('last.csv',header=None)
last['user'] = last.apply(lambda x: x.str.split()[0][0], axis =1)
last['month'] = last.apply(lambda x: x.str.split()[0][4], axis =1)
last1 = last.loc[(last.user != 'wtmp') & (last.month.isin(months)),['user','month']]
last1['count']=0
last2=last1.groupby(by=['user','month'])['count'].count()
last3=last2.reset_index()
#last3

# obtain data containing psql names and oids
dboid = pd.read_csv('db_names.csv')
#dboid

# obtain data containing the sizes of the folders (oid)
sizes = pd.read_csv('db_sizes.csv',delimiter='\t',header=None).rename(columns={0:'size',1:'oid'})
sizes = sizes.loc[sizes.oid != 'pgsql_tmp',:]
sizes.oid = sizes.oid.astype('int64')
#print(sizes.loc[sizes['oid']==16386,:])
#sizes

# join size and oid data on oid
data = pd.merge(sizes, dboid, on='oid')
#data

# create user column from datname column on joined data
data2 = data.copy()
data2.loc[:,'user'] = data2.datname.apply(lambda x: x[:-3])
#data2

# join last and previously joined data on user
data3=pd.merge(last3, data2, on='user',how='right')
#data3

# create sizeGB column from size column that is sort friendly
data4=data3.copy()
data4.sizeU=0
data4.loc[:,'sizeGB']=data4['size'].apply(lambda x: x[:-1] if x[-1]=='G' else float(str(x)[:-1])/1024)
data4['sizeGB']=data4['sizeGB'].astype('float64')
data4.sort_values('sizeGB',ascending=False,inplace=True)
#data4.reset_index()

data4.to_csv('last_M_sizes.csv',index=False)