drop table if exists users;
create table users (
  id integer primary key autoincrement,
  username text not null,
  pass text not null,
  nation text not null,
  voting bool not null
);

Insert into users (username, pass,nation,voting)
values ("Andrew","47a2228020ec2e5795a2d135e66bf255", "Jin", 1);
Insert into users (username, pass,nation,voting)
values ("Justin","3ad0b002b4ffc9662a42dde592b63b7b", "Stonevail", 1);
Insert into users (username, pass,nation,voting)
values ("Eliza","68c9b561849c10f8b516f8fc24d978e1", "Stonevail", 1);
Insert into users (username, pass,nation,voting)
values ("Tyler", "469d497f8e88099ae11cb685af2e2abd", "Jin", 1);
Insert into users (username, pass,nation,voting)
values ("Miles","a70cb8d32da253be008115c7990c0547", "Jin", 0);
Insert into users (username, pass,nation,voting)
values ("Kailey", "3749b371ffbb72a4b57aec5f4fa4954a", "Stonevail", 1);

