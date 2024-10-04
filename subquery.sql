-- # 서브쿼리 p.153

-- ## 단일 행 서브쿼리 

-- p.157
-- 예제1) 7566번 사원보다 급여를 많이 받는 사원의 이름, 급여를 조회하라 
select ename, job
from emp
where job = (select job from emp where empno=7566);
-- where조건절에서 서브쿼리의 값 job을 구한 후에 
-- 메인 쿼리의 job과 비교하여 같으면 출력
            
-- 예제2) EMP 테이블에서 사원번호가 7521인 사원과 업무가 같고, 
-- 급여가 7934인 사원보다 많은 사원의 사원번호, 이름, 담당업무, 입사일자, 급여를 조회하라
select empno, ename, job, hiredate, sal
from emp
where job = (select job
             from emp
             where empno=7521)
AND sal > (select sal
           from emp
           where empno=7934);

-- 예제3) EMP 테이블에서 급여를 제일 많이 받는 사원의 이름, 부서번호, 급여, 입사일을 조회하라
-- 급여를 제일 많이 받는 것이---> 최대값
select ename, deptno, sal, hiredate
from emp
where sal = (select MAX(sal) from emp);
-- 급여의 최대값에 해당하는 사원의 이름, 부서번호 급여, 입사일자를 출력             
-- 급여의 최대값을 구하는 문장 select MAX(sal) from emp;

select ename, deptno, sal, hiredate
from emp
where sal = max(sal);
-- 그룹함수는 조건절을 사용할때 having절을 사용해야 된다.
-- where 조건절에는 그룹함수를 사용하면 안된다.

--예제4) EMP 테이블에서 급여의 평균보다 적은 사원의 
-- 사원번호, 이름, 담당 업무, 급여 , 부서번호를 출력하여라
select empno, ename, job, sal, deptno
from emp
where sal < (select ROUND(AVG(sal))from emp);
--급여의 평균값보다 적은 사원번호, 이름, 부서, 급여, 부서번호를 출력 
--급여의 평균값을 구하는 문장 select ROUND(AVG(sal)) from emp;

--예제5) EMP 테이블에서 사원의 급여가 20번 부서의 최소 급여보다 많은 부서를 조회하라
-- 부서번호가 20번의 최소급여보다 큰 값을 가진 다른 부서의 부서번호와 최소값을 출력하시오

--부서번호가 20번의 최소급여를 츨력하는 문장
select MIN(sal) from emp
where deptno=20;

select deptno, min(sal)
from emp
group by deptno
having min(sal) > (select MIN(sal) from emp where deptno=20);

-- ## 다중행 서브쿼리

-- p159 
-- 예제1) 다음 문장의 결과를 확인한다.
select empno, ename, sal, deptno
from emp
where sal = (select MAX(sal) from emp group by deptno);
-- 오류발생의 원인이 '=' 연산자에서는 1개 값만 비교하기  때문에 오류발생.
select MAX(sal)
from emp
group by deptno;             
-- 의 출력값은 여러개가 나오는데  '=' 연산자에서는 1개 값만 비교한다.

-- 해결방법
select empno, ename, sal, deptno
from emp
where sal IN (select MAX(sal)
             from emp
             group by deptno);
--sal값이 10번 부서번호의 최대값 5000또는
--sal값이 20번 부서번호의 최대값 3000또는
--sal값이 30번 부서번호의 최대값 2850을 갖는 것을 출력

--예제2) 업무가 'SALESMAN'인 최소 한 명 이상의 사원보다 급여를 많이 받는 사원의 이름,급여,업무를 조회
-- (다르게 해석하면 업무가 'SALESMAN'인 최소 급여보다 많이 받는 사원)
-- 'SALESMAN'의 급여
select sal 
from emp
where job='SALESMAN';
--job이 'SALESMAN'인 사람들의 급여를 출력한다.

select ename, sal, job
from emp
where job != 'SALESMAN'
AND sal > (select MIN(sal) 
           from emp
           where job='SALESMAN');
-- sal값이 업무가 'SALESMAN'인 최소 급여보다 많이 받는것

-- ANY연산자 수행tp          
select ename, sal, job
from emp
where job != 'SALESMAN'
AND sal > ANY (select sal 
           from emp
           where job='SALESMAN');
-- sal값들 중에서 최소값 보다 큰 값을 출력           
           
--예제3)업무가 'SALESMAN'인 모든 사원보다 급여를 많이 받는 사원의 이름,급여, 업무, 입사일, 부서번호를 조회하라
--(다르게 해석하면 업무가 'SALESMAN'인 모든 사원의 최대값보다 큰값)
select ename, sal, job, hiredate, deptno
from emp
where job != 'SALESMAN'
AND sal > ALL (select sal 
           from emp
           where job='SALESMAN');
--ALL은 job이 'SALESMAN'인 사람들의 모든 급여라는 뜻으로 
--모든 급여보다 크다는 뜻은 job이 'SALESMAN'인 사람들의 최대값이 된다.

--예제 3-1
select ename, sal, job, hiredate, deptno
from emp
where job != 'SALESMAN'
AND sal > (select MAX(sal) 
           from emp
           where job='SALESMAN');

-- ## 다중 열 서브쿼리
-- 2개 이상의 컬럼의 값을 리턴해 준다.

-- p126
--예제 1) FORD, BLAKE의 관리자 및 부서가 같은 사원의 정보 조회를 조회하는
--FORD의 관리자 및 부서
select mgr, deptno
from emp
where ename = 'FORD';
--결과값 출력 : 7566   20

select mgr, deptno
from emp
where ename = 'BLAKE';
--결과값 출력 : 7839   30

select ename, mgr, deptno
from emp
where MGR IN (select mgr 
              from emp
              where ename IN('FORD','BLAKE'))
AND deptno IN(select deptno 
              from emp
              where ename IN('FORD','BLAKE'))
AND ename NOT IN('FORD','BLAKE');
--출력결과가 문제와 다르게 출력된다.
--(7566,20) 또는 (7839,30)이 출력되어야 하는데
--위 문장의 출력결과는 
--JONES	7839	20
--SCOTT	7566	20
--SCOTT	7566	20만 출력되어야 한다.

--그래서, PAIRWISE서브쿼리 방식이 필요하다.
--예제2) PAIRWISE subquery 다음문장을 예제1 결과와 비교해본다.
select ename, mgr, deptno
from emp
where (MGR, deptno) IN (select mgr, deptno from emp where ename IN('FORD','BLAKE'))
AND ename NOT IN('FORD','BLAKE');
-- 7566과 20인 경우와 7839와 30인 데이터를 출력하는데 조건에 맞는것은
--결과값 : SCOTT	7566	20 이다.

-- 상호 연관 서브 쿼리
-- 메인쿼리의 값을 서브쿼리에 넘겨주고, 서브 쿼리를 수행한
-- 후에 그 결과를 다시 메인쿼리로 반환해서 수행하는 것이다.
-- p162

-- 예제1) 소속부서의 평균 급여보다 많은 급여를 받는 사원의 이름, 급여
--,부서번호, 임사일, 업무 정보를 조회
select deptno, ROUND(AVG(sal))
from emp
group by deptno;

--정답
select ename, sal, deptno, hiredate, job
from emp ME
where sal > (select AVG(sal)
             from emp SE
             where SE.deptno = ME.deptno);
--메인쿼리 테이블의 별칭은 ME, 서브쿼리 테이블의 별칭은 SE로 설정
--메인쿼리에서 1개의 데이터(레코드)를 읽어서 서브쿼리의
--서번호 ME.deptno에게 값을 넘겨준다.
--서브쿼리는 메인쿼리의 부서번호를 받은 것으로 평균 급여를 구한후
--다시 메인 쿼리는 서브쿼리의 평균 급여보다 큰 급여의 직원을 출력
--단점 시간이 많이 소요됨(2중 for문과 같은 시간이 소요됨)
--전체 행은 14개 이기 때문에 14*14번 반복하게 된다.

-- FROM절 서브쿼리
-- FROM절 서브쿼리를 인라인 뷰(inline view)라고 한다.
-- 상호연관으로 변경가능한 경우에도 inline view 가 성능이 더 좋음
-- inline view 반드시 alias 지원
-- p166

--예제1) 다음 수행결과를 확인한다.
-- from 절 서브쿼리1
select * from emp where deptno=10;
--의 결과는 
--7782	CLARK	MANAGER	7839	11/01/09	2450		10
--7839	KING	PRESIDENT		91/11/17	5000		10
--7934	MILLER	CLERK	7782	20/01/23	1300		10
--은 테이블 별칭을 e로 설정한다.

-- from 절 서브쿼리2
select * from dept;
--결과
--10	ACCOUNTING	A1
--20	RESEARCH	B1
--30	SALES	C1
--40	OPERATIONS	A1
--50	INSA	
--로 별칭은 d로 한다.

select e.empno, e.ename, e.deptno, d.dname, d.loc_code
from (select * from emp where deptno=10) e,
     (select * from dept) d
where e.deptno = d.deptno;     
--e 테이블과 d 테이블에서 부서번호가 같은 것만 출력한다.

-- TOP-N 서브쿼리
-- p168
-- 슈도컬럼(peseudo column)
-- 예제1)
select ROWNUM, empno, ename, sal --세번째 실행
from emp --첫번째 실행
where ROWNUM < 4;--두번째 실행
--emp테이블에 있는 데이터를 읽어서 select문에서
--ROWNUM은 일련의 번호를 붙인다.
--ROWNUM값이 4보다 작은 것만 출력한다.
--출력결과
--1	7369	SMITH	800
--2	7499	ALLEN	1600
--3	7521	WARD	1250
select ROWNUM, empno, ename, sal --세번째 실행
from emp --첫번째 실행
where ROWNUM < 4--두번째 실행
order by sal desc; --네번째 실행
--출력결과
--2	7499	ALLEN	1600
--3	7521	WARD	1250
--1	7369	SMITH	800

--예제2
select ROWNUM, empno, ename, sal
from (select empno, ename, sal
      from emp
      order by sal desc)
where ROWNUM < 4;
--from절에 sal값을 기준으로 내림차순으로 정렬한 테이블을 가지고
--ROWNUM값을 부여한다.
--출력결과
--1	7839	KING	5000
--2	7788	SCOTT	3000
--3	7902	FORD	3000

--171page
--스칼라 서브쿼리
--하나의 행에서 하나의 컬럼 값만 반환하는 서브쿼리를 스칼라 스브쿼리라고 한다.

--예제1 CASE 표현식에 스칼라 서브쿼리를 사용한다.
select empno, ename, deptno,
       (case when deptno=(select deptno from dept where loc_code='B1')
             then 'TOP' else 'BRENCH' end) as location
from emp;
-- deptno값과 서브쿼리의 loc_code값이 'B1'인 데이터의 부서번호(deptno)와 같은 경우에
-- 'Top'을 출력하고, 다르면 'BRENCH'를 출력한다.

--예제2. 사원이름, 부서번호, 급여, 소속부서의 평균연봉을 조회하라
select empno, deptno, sal,
       (select AVG(sal) from emp where deptno=e.deptno) as asal
from emp e;
-- 메인 쿼리에서 데이터를 한 행 읽은 후에 스칼라 서브쿼리가 데이터 갯수 만큼 반복해서
-- 부서번호가 같은 경우에만 평균을 출력한다.
-- 따라서 emp테이블의 데이터를 모두 읽은 후에 출력결과를 보면 같은 부서번호의 결과는
-- 같이 출력된다.

--예제3. ORDER BY절에 스칼라 서브쿼리 사용한 경우
select empno, ename, deptno, hiredate
from emp e
order by (select dname from dept where deptno=e.deptno) desc;
--emp테이블의 부서번호와 dept테이블의 부서번호가 같을 경우에 dname값을 가지고
--내림차순을 하는데 dname값을 출력할수 없가 때문에 3-1과 같이 수정해서 실행해 보자

--3-1번
select empno, ename, deptno, hiredate, 
      (select dname from dept where deptno=e.deptno) as Name
from emp e 
order by Name desc;

--EXISTS 연산자
-- 174페이지
--예제1. 소속 사원이 존재하는 부서의 부서번호, 부서명 조회한다.
select deptno, dname
from dept d
where EXISTS (select 'A'
              from emp
              where deptno = d.deptno);
--dept테이블에서 한행의 데이터를 읽어서 where조건절의
--서브쿼리에 dept테이블의 deptno(부서번호를) 넘기고,
--서브쿼리에서 emp테이블의 deptno(부서번호)와 dept테이블의 부서번호가
--같은 것이 있을 경우에는 더 이상 emp 테이블의 데이터를 읽지 않는다.
--EXISTS연산자는 같은 값이 있을 경우에 서브쿼리의 실행을 종료 하기 위해서
--실행속도를 증가시킨다. 섭쿼리의 'A'는 다른 값을 사용해도 된다.

--예제2. 다음 수행결과를 확인한다.
select empno, ename, job, hiredate, sal, deptno
from emp e
where EXISTS (select 1
              from emp
              where e.empno = mgr)
order by empno;
--메인쿼리에서 emp테이블의 데이터 1행의 컬럼중에서 empno값을
--서브쿼리에 넘겨주고, 서브쿼리에서 메인쿼리의 empno와 서브쿼리의
--mgr값이 같을 경우 서브쿼리는 종료되고 true값을 넘겨준다.

--예제3. 이 문제는 테이블이 없어서 skip

--WITH구문
--176페이지
--같은 질의 블록을 여러번 참조하거나 조인 및 집게를 해야 하는 경우 매우 유용하다
--해당 절이 질의에서 여러번 사용될지라도 한번만 실행되므로 성능이 향상된다.
--예제1
select deptno, sum(sal)
from emp
group by deptno
having sum(sal) > (select avg(sum(sal))
                   from emp
                   group by deptno);
--서브쿼리는 부서벌 급여의 전체 합계의 평균을 출력하는 것으로
--메인쿼리의 부서별 급여합이 서브쿼리의 평균보다 큰 경우 출력

--WITH 절을 사용하면 복합질의에서 여러번 발생하는 같은 질의 볼록 결과를 사용자의
--임시테이블에 저장된다.
--예제2.
with ABC as (select deptno, sum(sal) as sum
             from emp
             group by deptno)
select *
from ABC
where sum > (select avg(sum) from ABC);