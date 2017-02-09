Mysql 物理备份, 依赖 xtrabacdkup

# 创建备份用户

```sql
create user 'bkpuser'@'localhost' identified by 'bkppassword';
    
revoke all privileges,grant option from 'bkpuser'@'localhost';

grant process,reload,lock tables,replication client on *.* to 'bkpuser'@'localhost';

flush privileges;
```
# options:

-h show help

-b backup, either incremental or full, "-b inc" or "-b full"

-r restore, format:%Y-%m-%d_%H%M, "-r 2017-01-01_1101" or "-r latest"
