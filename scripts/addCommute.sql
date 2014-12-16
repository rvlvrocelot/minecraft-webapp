drop table if exists commute;
create table commute(
train text not null,
id integer primary key autoincrement,
Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
comment text not null,
commuteTime real not null ,
trip real not null
);
