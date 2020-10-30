use MyDB;

CREATE TABLE userTbl -- 회원 테이블
( userID  	CHAR(8) NOT NULL PRIMARY KEY, -- 사용자아이디
  name    	VARCHAR(10) NOT NULL, -- 이름
  birthYear INT NOT NULL,  -- 출생년도
  addr	  	CHAR(2) NOT NULL, -- 지역(경기,서울,경남 식으로 2글자만입력)
  mobile1	CHAR(3), -- 휴대폰의 국번(011, 016, 017, 018, 019, 010 등)
  mobile2	CHAR(8), -- 휴대폰의 나머지 전화번호(하이픈제외)
  height    	SMALLINT,  -- 키
  mDate    	DATE  -- 회원 가입일
)engine=InnoDB default charset=utf8;

CREATE TABLE buyTbl -- 회원 구매 테이블
(  num 		INT AUTO_INCREMENT NOT NULL PRIMARY KEY, -- 순번(PK)
   userID  	CHAR(8) NOT NULL, -- 아이디(FK)
   prodName 	CHAR(6) NOT NULL, --  물품명
   groupName 	CHAR(4)  , -- 분류
   price     	INT  NOT NULL, -- 단가
   amount    	SMALLINT  NOT NULL, -- 수량
   FOREIGN KEY (userID) REFERENCES userTbl(userID)
)engine=InnoDB default charset=utf8;


INSERT INTO userTbl VALUES('LSG', '이승기', 1987, '서울', '011', '1111111', 182, '2008-8-8');
INSERT INTO userTbl VALUES('KBS', '김범수', 1979, '경남', '011', '2222222', 173, '2012-4-4');
INSERT INTO userTbl VALUES('KKH', '김경호', 1971, '전남', '019', '3333333', 177, '2007-7-7');
INSERT INTO userTbl VALUES('JYP', '조용필', 1950, '경기', '011', '4444444', 166, '2009-4-4');
INSERT INTO userTbl VALUES('SSK', '성시경', 1979, '서울', NULL  , NULL      , 186, '2013-12-12');
INSERT INTO userTbl VALUES('LJB', '임재범', 1963, '서울', '016', '6666666', 182, '2009-9-9');
INSERT INTO userTbl VALUES('YJS', '윤종신', 1969, '경남', NULL  , NULL      , 170, '2005-5-5');
INSERT INTO userTbl VALUES('EJW', '은지원', 1972, '경북', '011', '8888888', 174, '2014-3-3');
INSERT INTO userTbl VALUES('JKW', '조관우', 1965, '경기', '018', '9999999', 172, '2010-10-10');
INSERT INTO userTbl VALUES('BBK', '바비킴', 1973, '서울', '010', '0000000', 176, '2013-5-5');
INSERT INTO buyTbl VALUES(NULL, 'KBS', '운동화', NULL   , 30,   2);
INSERT INTO buyTbl VALUES(NULL, 'KBS', '노트북', '전자', 1000, 1);
INSERT INTO buyTbl VALUES(NULL, 'JYP', '모니터', '전자', 200,  1);
INSERT INTO buyTbl VALUES(NULL, 'BBK', '모니터', '전자', 200,  5);
INSERT INTO buyTbl VALUES(NULL, 'KBS', '청바지', '의류', 50,   3);
INSERT INTO buyTbl VALUES(NULL, 'BBK', '메모리', '전자', 80,  10);
INSERT INTO buyTbl VALUES(NULL, 'SSK', '책', '서적', 15,   5);
INSERT INTO buyTbl VALUES(NULL, 'EJW', '책', '서적', 15,   2);
INSERT INTO buyTbl VALUES(NULL, 'EJW', '청바지', '의류', 50,   1);
INSERT INTO buyTbl VALUES(NULL, 'BBK', '운동화', NULL, 30,   2);
INSERT INTO buyTbl VALUES(NULL, 'EJW', '책', '서적', 15,   1);
INSERT INTO buyTbl VALUES(NULL, 'BBK', '운동화', NULL, 30,   2);

select * from userTbl;
select * from buyTbl;

SELECT userTbl.userID, name, sum(price * amount) as '총 구매액', grade as '고객등급' 
FROM userTbl
left join buyTbl on userTbl.userID = buyTbl.userID 
group by(userID)
order by sum(price * amount) desc;
	
    
SELECT userTbl.userID, name, (price * amount) as '총 구매액', grade as '고객등급' 
FROM userTbl
left join buyTbl on userTbl.userID = buyTbl.userID 
group by(userID)
order by sum(price * amount) desc;
    
select userTbl.userID, name, sum(price * amount) as '총 구매액', grade as '고객등급'
from userTbl
left join buyTbl on userTbl.userID = buyTbl.userID
group by userID
order by sum(price * amount) desc;

select userTbl.userID, name, sum(price * amount) as '총 구매액', grade as '고객등급'
from userTbl
left join buyTbl on userTbl.userID = buyTbl.userID
group by buyTbl.userID
order by sum(price * amount) desc;

select *
from userTbl
left join buyTbl on userTbl.userID = buyTbl.userID;

SELECT userID, sum(price * amount) as '구매금액' FROM buyTbl group by(userID) order by sum(price * amount) desc;
alter table userTbl ADD grade varchar(5);
alter table userTbl drop column grade;

drop procedure if exists userG;

alter database mydb character set utf8 collate utf8_general_ci;

DELIMITER $$
CREATE PROCEDURE userG() 
BEGIN
    declare Perform int;
	declare vGrade VARCHAR(10);
    declare vuserID varchar(10);
    declare endOfRow boolean default false;
    
    DECLARE userCursor CURSOR FOR
		SELECT userTbl.userID, sum(price * amount) 
		FROM userTbl
        left join buyTbl 
        on userTbl.userID = buyTbl.userID 
        group by(userID);
    
    declare continue handler for not found set endOfRow = true;
    
    alter table userTbl ADD grade varchar(5);
    
    open userCursor;
    
    cursor_loop: LOOP
		FETCH userCursor INTO vuserID, Perform;
		
        if endOfRow then
			leave cursor_loop;
        end if;
        
        if Perform >= 1500 then
			set vGrade = '최우수고객';
		else
			if Perform >= 1000 then
				set vGrade = '우수고객';
			else
				if Perform >= 1 then
					set vGrade = '일반고객';
				else
					set vGrade = '유령고객';
				end if;
			end if;
		end if;
	
		update userTbl set grade = vGrade where userID = vuserID;
    
	end loop cursor_loop;

	select userTbl.userID, name, sum(price * amount) as '총 구매액', grade as '고객등급'
	from userTbl
	left join buyTbl on userTbl.userID = buyTbl.userID
	group by userID
	order by sum(price * amount) desc;
   
	close userCursor;
    
END $$
DELIMITER ;

call userG();