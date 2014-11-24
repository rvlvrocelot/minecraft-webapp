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
values ("Eliza","0089b0dbedfd355dfcf9ce55c0307f42");


drop table if exists announcements;
create table announcements (
  id integer primary key autoincrement,
  user text not null, 
  Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  announcement text not null,
  details text not null
);



