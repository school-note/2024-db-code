--분석함수
--1. 개발 생산성 향상시킬수 있다.
--2. SQL튜닝으로 성능을 향상 시킬수 있다.
--3. 쿼리를 간단하게 하여 가독성을 향상시킬수 있다.
--4. DW(Data Warehousing)분야에 사용한다.
-- (사용자의 의사결정에 도움을 주기 위하여, 기간 시스템의 데이터베이스에 축적된 데이터를 공통의 형식으로 변환해서 관리하는 데이터베이스를 말한다.)
--5. select 절에서만 사용

--187page
--예제1. 사원번호, 이름, 부서번호, 급여, RANK함수 이용해서 부서내에서
--급여가 많은 사원부터 순위를 부여한다.
select empno, ename, deptno, sal,
       RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) as "RANK"
from emp;
--분석함수는 select절에만 사용하는 것으로
--deptno(부서번호)를 기준으로 그룹을 설정하고, 그룹별 급여(sal)를
--중심으로 내림차순하고, 그룹별로 순위를 부여하는 것이다.
--동석차가 있을 경우에는 같은 순위를 부여하고 동석차가 2명일 경우에는
--다음 순위가 동석차 갯수 만큼 더해서 부여 된다.

--예제2. 사원번호, 이름, 부서번호, 급여, RANK함수 이용해서 부서내에서
--급여가 많은 사원부터 순위를 부여한다.(DENSE_RANK 함수이용)
select empno, ename, deptno, sal,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) as "RANK"
from emp;
--위의 예제가 같으나 동석차가 있을 경우에는 같은 순위를 부여하고 
--동석차가 여러명일 경우에도 그 다음 순위에는 1만 증가해서 붙인다.

--예제3. 사원번호, 이름, 연봉, 입사일, 순번조회(급여가 많은 순으로, 같은 급여를
--받을 경우에는 입사일일 빠른 사람부터 순번 부여)
select empno, ename, sal, hiredate,
       row_number() over (ORDER BY sal DESC, hiredate ASC) as "순번"
from emp;
--sal값을 가지고 내림차순으로 정렬해서 순번을 부여하는데, sal값이 같을 경우에는
--hiredate(입사일자)를 오름차순으로 하여 순번을 부여한다.

--예제4. 사원을 연봉 기준으로 4등급으로 부여해라
select ename, sal, 
       NTILE(4) OVER(ORDER BY sal)
from emp;
--전체 14줄인데 4등급으로 나누면 3개씩 나눌수 있는데 2개가 남게 된다.
--4그룹이 만들어지고, 한 그룹당 3개씩 부여되는데 2개 남는 것은 
--위의 그룹부터 하나씩 부여된다. 따라서 첫번째 그룹 4개,
--두번째그룹 4개, 나머지는 3개씩 부여된다.

--예제5 사원이름, 부서번호, 급여, 전체급여합계, 부서별급여합계를 조회한다.
select ename, deptno, sal,
       SUM(sal) over() "total_sum", --전체합계를 하나의 컬럼에 모든 행에 출력한다.
       SUM(sal) over (partition by deptno) "dept_sum" --부서별 합계를 부서에 맞게 출력
from emp;       

--예제6 사원이름, 업무, 급여, 업무별 급여평균, 해당업무의 최대급여를 출력한다.
select ename, job, sal,
       AVG(sal) over(partition by job) "job_avg", --부서별 급여평균을 해당부서에 출력한다.
       MAX(sal) over(partition by job) "job_max" --부서별 최대값을 해당 부서에 맞게 출력
from emp;       

--예제7 사원이름, 부서번호, 급여합계를 3줄씩 더한 결과값, 누적합계를 출력한다.
select ename, deptno, sal,
       sum(sal) over(order by sal rows between 1 preceding and 1 following) "sum1",
       -- 예를 들면 결과가 다음과 같을 때 
       --ENAME  DEPTNO  sal     sum1    sum2
       --SMITH	20	    800	    1750	800
       --JAMES	30	    950	    2850	1750
       --ADAMS	20	    1100	3300	2850
       --WARD	30	    1250	3600	4100
       --위의 SMITH의 경우에 sum1(1750)값은 800+950이다. 
       --위의 JAMES의 경우에 sum1(2850)값은 800+950+1100이다. 
       sum(sal) over(order by sal rows unbounded preceding) "sum2"
       -- 1행부터 누적하는 값이 출력된다.
from emp;       

--예제8 다음 결과를 확인한다.
select empno, ename, deptno, sal,
       sum(sal) over(order by deptno, empno 
       --부서번호를 중심으로 오름차순하고 같으면 사원번호를 기준으로 오름차순 정렬한다.              
                     rows between unbounded preceding --unbounded는 무한한 뜻으로 첫번째 행부터
                     and unbounded following) sal1, --마지막 행까지의 급여 합계를 출력하는 문장이다. 
       
       sum(sal) over(order by deptno, empno 
                     rows between unbounded preceding --unbounded는 무한한 뜻으로 첫번째 행부터
                     and current row) sal2, --current는 현재라는 뜻으로 현재행까지의 합을 출력한다.
                     --예를 들면
                     --EMPNO   ENAME    DEPTNO   SAL    SAL1    SAL2    SAL3
                     --7782	   CLARK	10	     2450	29025	2450	29025
                     --7839	   KING	    10	     5000	29025	7450	26575
                     --7934	   MILLER	10	     1300	29025	8750	21575
                     --KING을 예를 들면 SAL2(7450)값은 SAL의 2450+5000이다. 
                     
       sum(sal) over(order by deptno, empno 
                     rows between current row --현재행부터(current row) 
                     and unbounded following) sal3 --마지막 행까지의 합을 출력하는 문장이다.
                     --예를 들면
                     --EMPNO   ENAME    DEPTNO   SAL    SAL1    SAL2    SAL3
                     --7782	   CLARK	10	     2450	29025	2450	29025
                     --7839	   KING	    10	     5000	29025	7450	26575
                     --7934	   MILLER	10	     1300	29025	8750	21575
                     --CLARK의   SAL3값은 첫번째 행부터 마지막 행까지의 합
                     --KING의    SAL3값은 두번째 행부터 마지막 행까지의 합
                     --MILLER의  SAL3값은 세번째 행부터 마지막 행까지의 합
from emp;                     

--예제9 사원이름, 부서번호, 연봉(급여), 본인 다음의 연봉(급여)값을 조회
select ename, deptno, sal,
       LEAD(sal, 1, 0) over(order by sal) "next_sal",
       --sal값의 다음 값을 출력한다. 다음값이 없을 경우에는 0값을 출력한다.
       LEAD(sal, 1, sal) over(order by sal) "next_sal2"
       --sal값의 다음 값을 출력한다. 다음값이 없을 경우에는 sal값을 출력한다.
from emp;       

--예제9-1
select ename, deptno, sal,
       LEAD(sal, 2, 0) over(order by sal) "next_sal",
       --sal값의 다음 다음(2번째)값을 출력한다. 다음값이 없을 경우에는 0값을 출력한다.
       LEAD(sal, 2, sal) over(order by sal) "next_sal2"
       --sal값의 다음 다음(2번째)값을 출력한다. 다음값이 없을 경우에는 sal값을 출력한다.
from emp; 

--예제10 사원이름, 부서번호, 연봉(급여), 본인의 이전 연봉(급여)를 조회
select ename, deptno, sal,
       LAG(sal, 1, 0) over(order by sal) "prev_sal1",
       --sal값의 이전 값을 출력한다. 이전값이 없을 경우에는 0값을 출력한다.
       LAG(sal, 1, sal) over(order by sal) "prev_sal2",
       --sal값의 다음 값을 출력한다. 이전값이 없을 경우에는 sal값을 출력한다.
       LAG(sal, 1, sal) over(partition by deptno order by sal) "prev_sal3"
       -- 이경우에는 10-1예제 확인
from emp;       

--예제10-1 사원이름, 부서번호, 연봉(급여), 본인의 이전 연봉(급여)를 조회
select ename, deptno, sal,
       --LAG(sal, 1, 0) over(order by sal) "prev_sal1",
       --LAG(sal, 1, sal) over(order by sal) "prev_sal2",
       LAG(sal, 1, sal) over(partition by deptno order by sal) "prev_sal3"
       --부서번호별로 그룹으로 설정한 후에 부서번호별 이전 급여를 출력한다.
       --이전급여가 없을 경우 현재값으로 설정한다.
from emp
order by deptno;       

--11. 30번 부서원들의 이름, 급여, 입사일, 해당사원 중 급여가 가장 많은 사원의 입사일자를 
--각 행에 반환한다.
select ename, sal, hiredate,
       LAST_VALUE(hiredate) over (order by sal
                                  rows between unbounded preceding
                                  and unbounded following) as lv
--급여중에서 처음부터 끝까지 오름 차순하는데 부서번호가 30번 경우에
--출룍을 하는데 맨 마지막에 오는 입사일자(hirdate) 값을 가지고 출력한다.
from emp
where deptno=30;

--11-1.
select ename, deptno, sal, hiredate,
       LAST_VALUE(hiredate) over (order by sal) as lv
       --급여를 가지고 오름차순으로 정렬하는데 같은 값이 나올경우
       --나중에 나오는 입사일자를 출력한다.
from emp
where deptno=30;

--예제12 다음 결과를 확인한다.
select ename, sal, hiredate,
       FIRST_VALUE(hiredate) over(order by sal 
                     rows between unbounded preceding --unbounded는 무한한 뜻으로 첫번째 행부터
                     and unbounded following) as lv1, --마지막 행까지의 데이터에서 첫번째 데이터를 출력하는 것이다.
       FIRST_VALUE(ename) over(order by sal desc 
                     rows between unbounded preceding --unbounded는 무한한 뜻으로 첫번째 행부터
                     and unbounded following) as lv2 
                     --마지막 행까지의 급여 데이터에서 첫번째 이름을 출력하는 문장이다. 
from emp
where deptno = 30;                     

--예제12-1 12문제를 분리해서 출력해 보면 결과를 재대로 알수 있다.
select ename, sal, hiredate,
       FIRST_VALUE(hiredate) over(order by sal --FIRST_VALUE(hiredate)는 처음 입사일자의 값
                     rows between unbounded preceding --unbounded는 무한한 뜻으로 첫번째 행부터
                     and unbounded following) as lv1 
                     --마지막 행까지의 데이터에서 첫번째 데이터 입사일자를 출력하는 것이다.
from emp
where deptno = 30;                     

--예제12-2
select ename, sal, hiredate,
       FIRST_VALUE(ename) over(order by sal desc --FIRST_VALUE(ename)는 급여를 내림차순 했을때 처음 이름의 값
                     rows between unbounded preceding --unbounded는 무한한 뜻으로 첫번째 행부터
                     and unbounded following) as lv2 
                     --마지막 행까지의 급여 데이터에서 첫번째 이름을 출력하는 문장이다. 
from emp
where deptno = 30;                     
