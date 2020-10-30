use MyDB;

select *
from SuperOrders;

drop table SuperOrders;

create table member(
	Id			varchar(25) primary key,
    Password	varchar(100),
    Name		varchar(25),
    Email		varchar(100)
)engine=InnoDB default charset=utf8;

select *
from member;

create table score(
	name		varchar(20) primary key,
    kor			int,
    eng			int,
    math		int,
    total		int,
    average		int
)engine=InnoDB default charset=utf8;

select *, rank() over (order by total DESC) as 등수
from score;

select *, rank() as 등수
from score;

create table tb_member(
	id			varchar(20) primary key,
    pwd			varchar(20),
    name		varchar(20),
    tel			varchar(13),
    addr		varchar(100),
    birth		varchar(8),
    job			varchar(50),
    gender		varchar(1),
    email		varchar(50),
    intro		varchar(1000)
)engine=InnoDB default charset=utf8;

select * from tb_member;

