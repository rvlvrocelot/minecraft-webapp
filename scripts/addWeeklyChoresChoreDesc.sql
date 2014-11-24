drop table if exists weeklyChores;
create table weeklyChores (
  id integer primary key autoincrement,
  person text not null,
  choreid integer not null,
  completed int not null
);

drop table if exists choreList;
create table choreList (
  id integer primary key autoincrement,
  choreid integer not null,
  choreSub text not null,
  subComplete text
);

drop table if exists choreDesc;
create table choreDesc (
  id integer primary key autoincrement,
  choreid integer not null,
  desc text not null
);

Insert into weeklyChores (person, choreid, completed)
values("Ryder",0, 0);
Insert into weeklyChores (person, choreid, completed)
values("Andrew",1, 0);
Insert into weeklyChores (person, choreid, completed)
values("Anita",2, 0);

Insert into choreDesc(choreid,desc)
values(0,"Kitchen Duty");
Insert into choreDesc(choreid,desc)
values(1,"Bathroom Duty");
Insert into choreDesc(choreid,desc)
values(2,"Livingroom Duty");

Insert into choreList (choreid, choreSub, subComplete)
values(0, "Clean kitchen counter",0);
Insert into choreList (choreid, choreSub, subComplete)
values(0, "Clean stove top",0);
Insert into choreList (choreid, choreSub, subComplete)
values(0, "Clear expired food from fridge",0);
Insert into choreList (choreid, choreSub, subComplete)
values(0, "Clean Microwave",0);

Insert into choreList (choreid, choreSub, subComplete)
values(1, "Clean bathroom counter top",0);
Insert into choreList (choreid, choreSub, subComplete)
values(1, "Clean toilet",0);
Insert into choreList (choreid, choreSub, subComplete)
values(1, "Clean tub",0);
Insert into choreList (choreid, choreSub, subComplete)
values(1, "Ensure bathroom floor is clean",0);

Insert into choreList (choreid, choreSub, subComplete)
values(2, "Sweep living room floors",0);
Insert into choreList (choreid, choreSub, subComplete)
values(2, "Dust coffee table",0);
Insert into choreList (choreid, choreSub, subComplete)
values(2, "Wipe down kitchen table",0);
Insert into choreList (choreid, choreSub, subComplete)
values(2, "Take out trash (Monday or Tuesday)",0);
Insert into choreList (choreid, choreSub, subComplete)
values(2, "Take out trash (Wednesday or Thursday)",0);
Insert into choreList (choreid, choreSub, subComplete)
values(2, "Take out trash (Friday or Saturday)",0);


