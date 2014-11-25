drop table if exists entries;
create table entries (
  id integer primary key autoincrement,
  expense text not null,
  amount int not null,
  note text not null,
  name text not null
);

drop table if exists users;
create table users (
  id integer primary key autoincrement,
  username text not null,
  pass text not null
);

Insert into users (username, pass)
values ("Andrew","47a2228020ec2e5795a2d135e66bf255");
Insert into users (username, pass)
values ("Justin","3ad0b002b4ffc9662a42dde592b63b7b");
Insert into users (username, pass)
values ("Eliza","68c9b561849c10f8b516f8fc24d978e1");
Insert into users (username, pass)
values ("Tyler", "469d497f8e88099ae11cb685af2e2abd");
Insert into users (username, pass)
values ("Miles","a70cb8d32da253be008115c7990c0547");
Insert into users (username, pass)
values ("Kailey", "3749b371ffbb72a4b57aec5f4fa4954a");


drop table if exists announcements;
create table announcements (
  id integer primary key autoincrement,
  user text not null, 
  Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  announcement text not null,
  details text not null
);



