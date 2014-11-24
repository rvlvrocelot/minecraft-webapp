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
values ("Anita","de9d3c9be378d81b0244502a0f075b50");
Insert into users (username, pass)
values ("Andrew","566389c28abc48e488ac56d57fc338fa");
Insert into users (username, pass)
values ("Ryder","3717a626cab4016cb5066212cd97b189");


drop table if exists announcements;
create table announcements (
  id integer primary key autoincrement,
  user text not null, 
  Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  announcement text not null,
  details text not null
);



