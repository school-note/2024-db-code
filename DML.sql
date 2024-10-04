-- DML
-- 196page

--DML의 종류
--insert : 테이블에 새로운 행을 입력
--update : 테이블에 있는 행을 변경
--delete : 테이블에 있는 행을 삭제
--merge  : 테이블에 이미 데이터가 존재하면 update, 새로운 데이터이면 insert

--테이블에 새 행 추가
--dept테이블 예시
select * from dept;
--10	ACCOUNTING	A1
--20	RESEARCH	B1
--30	SALES	C1
--40	OPERATIONS	A1
--50	INSA	

--dept테이블에 새로운 행을 입력한다.
--첫번째 방법
insert into dept(deptno, dname, loc_code)
            values(70, 'MARKETING','B1');
--정의 되지 않은 컬럼은 default로 null값으로 지정된다.
--단, Primary key나 not null로 지정된 컬럼은 null이 허용되지 않는다.

--두번째 방법은
--모든 컬럼에 데이터를 입력하는 경우로 굳이 컬럼 리스트를 기록하지 않아도 된다.
--그러나 모든 컬럼에 해당하는 데이터를 기술해야 한다.
insert into dept values(80, 'EDUCATION','C1');

--NULL 값을 갖는 행 삽입
--암시적방법 : 열 목록에서 열을 생략한다.
--생략된 loc_code는 null값이 저장된다.
insert into dept(deptno, dname)
       values(90, 'MIS');
select * from dept;
--확인해 보면 별도로 값을 지정하지 않은 경우에는 null값이 출력된다.
--default값으로 설정한 경우에는 default값이 저장된다.

--명시적 방법 : null 키워드를 지정한다.
insert into dept(deptno, dname, loc_code)
       values(60, 'DIS', NULL);

--특정값을 갖는 행 삽입
--특정값을 갖는 행 삽입
insert into emp(empno, ename, hiredate)
       values(7233,'PAUL',sysdate);

--현재 사용자 이름 입력 : USER 함수 이용
insert into emp(empno, ename, sal)
       values(7234,user,3400);

--날짜 값을 입력할때는 TO_DATE 로 변환
insert into emp(empno, ename, hiredate)
       values(7533,'ELIVAS',TO_DATE('1997-02-05','YYYY-MM-DD'));

--서브쿼리를 이용한 INSERT문
create table new_emp ( --테이블 생성
   id number(4),
   name varchar2(10)
); 

--emp테이블 사원 이름 중에 A가 들어 있는 시원의 정보만 new_emp테이블에 입력한다.
--insert절의 열수와 서브쿼리의 열수가 일치해야 한다.
insert into new_emp
select empno, ename 
from emp
where ename like '%A%';

select * from new_emp;

--UPDATE문
update dept
set dname='test';
--where절을 생략하면 테이블의 모든행이 수정된다.

update emp
set    deptno=20, job='CLERK';
--모든 행의 deptno를 20으로, job을 'CLERK'으로 변경한다.

--where절을 사용하여 특정 행을 수정해야 한다.
update emp
set    deptno = 20
where  empno = 7233;

--205페이지
--예제1 7902 사원의 부서번호를 SCOTT 사원과 동일하게 변경하는 update문장을 작성
update emp --테이블 이름
set    deptno = (select deptno
                 from emp
                 where ename = 'SCOTT')
where  empno=7902;                 
--empno값이 7902인 데이터 중에서 'SCOTT'의 부서번호의 값으로 변경한다.

--예제2 7698번 사원의 업무는 7499의 업무와 동일하게 부서번호는 dept테이블의 SALES
--부서의 부서번호와 같은 번호로 변경하시오.
update emp
set    job = (select job 
              from emp
              where empno=7499), --사원번호가 7499인 사원의 업무(job)을 구함
    deptno = (select deptno
              from dept
              where dname='SALES') --dept테이블의 dname값이 'SALES'인 사원번호 값을 구함
where empno=7698;

--예제3 7698사원의 업무와 부서번호를 7499의 사원의 업무와 부서번호와 같도록
--변경작업을 수행하는 update작성하시오.
update emp
set (job, deptno) = (select job, deptno
                     from emp
                     where empno=7499) --사원번호가 7499인 사원의 job과 deptno값을 저장
where empno=7698;                     

--행 저거
--206페이지
delete dept
where deptno=30;
--부사번호가 30인 dept테이블의 데이터를 삭제한다.

--예제1 emp테이블의 사원번호 7233번 사원을 삭제하는 문장
delete emp 
where empno=7233;

--예제2 SCOTT 사원과 동일한 부서번호를 가진 사원을 삭제하는 delete를 작성
delete emp
where deptno = (select deptno
                from emp
                where ename='SCOTT');
--예제3 dept테이블의 'ACCOUNTING' 부서에 해당하는 부서번호에 해당하는
--emp테이블의 데이터 삭제하는 delete문장이다
delete emp
where  deptno = (select deptno
                 from dept
                 where dname = 'ACCOUNTING');