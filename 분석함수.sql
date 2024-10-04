--�м��Լ�
--1. ���� ���꼺 ����ų�� �ִ�.
--2. SQLƩ������ ������ ��� ��ų�� �ִ�.
--3. ������ �����ϰ� �Ͽ� �������� ����ų�� �ִ�.
--4. DW(Data Warehousing)�о߿� ����Ѵ�.
-- (������� �ǻ������ ������ �ֱ� ���Ͽ�, �Ⱓ �ý����� �����ͺ��̽��� ������ �����͸� ������ �������� ��ȯ�ؼ� �����ϴ� �����ͺ��̽��� ���Ѵ�.)
--5. select �������� ���

--187page
--����1. �����ȣ, �̸�, �μ���ȣ, �޿�, RANK�Լ� �̿��ؼ� �μ�������
--�޿��� ���� ������� ������ �ο��Ѵ�.
select empno, ename, deptno, sal,
       RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) as "RANK"
from emp;
--�м��Լ��� select������ ����ϴ� ������
--deptno(�μ���ȣ)�� �������� �׷��� �����ϰ�, �׷캰 �޿�(sal)��
--�߽����� ���������ϰ�, �׷캰�� ������ �ο��ϴ� ���̴�.
--�������� ���� ��쿡�� ���� ������ �ο��ϰ� �������� 2���� ��쿡��
--���� ������ ������ ���� ��ŭ ���ؼ� �ο� �ȴ�.

--����2. �����ȣ, �̸�, �μ���ȣ, �޿�, RANK�Լ� �̿��ؼ� �μ�������
--�޿��� ���� ������� ������ �ο��Ѵ�.(DENSE_RANK �Լ��̿�)
select empno, ename, deptno, sal,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) as "RANK"
from emp;
--���� ������ ������ �������� ���� ��쿡�� ���� ������ �ο��ϰ� 
--�������� �������� ��쿡�� �� ���� �������� 1�� �����ؼ� ���δ�.

--����3. �����ȣ, �̸�, ����, �Ի���, ������ȸ(�޿��� ���� ������, ���� �޿���
--���� ��쿡�� �Ի����� ���� ������� ���� �ο�)
select empno, ename, sal, hiredate,
       row_number() over (ORDER BY sal DESC, hiredate ASC) as "����"
from emp;
--sal���� ������ ������������ �����ؼ� ������ �ο��ϴµ�, sal���� ���� ��쿡��
--hiredate(�Ի�����)�� ������������ �Ͽ� ������ �ο��Ѵ�.

--����4. ����� ���� �������� 4������� �ο��ض�
select ename, sal, 
       NTILE(4) OVER(ORDER BY sal)
from emp;
--��ü 14���ε� 4������� ������ 3���� ������ �ִµ� 2���� ���� �ȴ�.
--4�׷��� ���������, �� �׷�� 3���� �ο��Ǵµ� 2�� ���� ���� 
--���� �׷���� �ϳ��� �ο��ȴ�. ���� ù��° �׷� 4��,
--�ι�°�׷� 4��, �������� 3���� �ο��ȴ�.

--����5 ����̸�, �μ���ȣ, �޿�, ��ü�޿��հ�, �μ����޿��հ踦 ��ȸ�Ѵ�.
select ename, deptno, sal,
       SUM(sal) over() "total_sum", --��ü�հ踦 �ϳ��� �÷��� ��� �࿡ ����Ѵ�.
       SUM(sal) over (partition by deptno) "dept_sum" --�μ��� �հ踦 �μ��� �°� ���
from emp;       

--����6 ����̸�, ����, �޿�, ������ �޿����, �ش������ �ִ�޿��� ����Ѵ�.
select ename, job, sal,
       AVG(sal) over(partition by job) "job_avg", --�μ��� �޿������ �ش�μ��� ����Ѵ�.
       MAX(sal) over(partition by job) "job_max" --�μ��� �ִ밪�� �ش� �μ��� �°� ���
from emp;       

--����7 ����̸�, �μ���ȣ, �޿��հ踦 3�پ� ���� �����, �����հ踦 ����Ѵ�.
select ename, deptno, sal,
       sum(sal) over(order by sal rows between 1 preceding and 1 following) "sum1",
       -- ���� ��� ����� ������ ���� �� 
       --ENAME  DEPTNO  sal     sum1    sum2
       --SMITH	20	    800	    1750	800
       --JAMES	30	    950	    2850	1750
       --ADAMS	20	    1100	3300	2850
       --WARD	30	    1250	3600	4100
       --���� SMITH�� ��쿡 sum1(1750)���� 800+950�̴�. 
       --���� JAMES�� ��쿡 sum1(2850)���� 800+950+1100�̴�. 
       sum(sal) over(order by sal rows unbounded preceding) "sum2"
       -- 1����� �����ϴ� ���� ��µȴ�.
from emp;       

--����8 ���� ����� Ȯ���Ѵ�.
select empno, ename, deptno, sal,
       sum(sal) over(order by deptno, empno 
       --�μ���ȣ�� �߽����� ���������ϰ� ������ �����ȣ�� �������� �������� �����Ѵ�.              
                     rows between unbounded preceding --unbounded�� ������ ������ ù��° �����
                     and unbounded following) sal1, --������ ������� �޿� �հ踦 ����ϴ� �����̴�. 
       
       sum(sal) over(order by deptno, empno 
                     rows between unbounded preceding --unbounded�� ������ ������ ù��° �����
                     and current row) sal2, --current�� ������ ������ ����������� ���� ����Ѵ�.
                     --���� ���
                     --EMPNO   ENAME    DEPTNO   SAL    SAL1    SAL2    SAL3
                     --7782	   CLARK	10	     2450	29025	2450	29025
                     --7839	   KING	    10	     5000	29025	7450	26575
                     --7934	   MILLER	10	     1300	29025	8750	21575
                     --KING�� ���� ��� SAL2(7450)���� SAL�� 2450+5000�̴�. 
                     
       sum(sal) over(order by deptno, empno 
                     rows between current row --���������(current row) 
                     and unbounded following) sal3 --������ ������� ���� ����ϴ� �����̴�.
                     --���� ���
                     --EMPNO   ENAME    DEPTNO   SAL    SAL1    SAL2    SAL3
                     --7782	   CLARK	10	     2450	29025	2450	29025
                     --7839	   KING	    10	     5000	29025	7450	26575
                     --7934	   MILLER	10	     1300	29025	8750	21575
                     --CLARK��   SAL3���� ù��° ����� ������ ������� ��
                     --KING��    SAL3���� �ι�° ����� ������ ������� ��
                     --MILLER��  SAL3���� ����° ����� ������ ������� ��
from emp;                     

--����9 ����̸�, �μ���ȣ, ����(�޿�), ���� ������ ����(�޿�)���� ��ȸ
select ename, deptno, sal,
       LEAD(sal, 1, 0) over(order by sal) "next_sal",
       --sal���� ���� ���� ����Ѵ�. �������� ���� ��쿡�� 0���� ����Ѵ�.
       LEAD(sal, 1, sal) over(order by sal) "next_sal2"
       --sal���� ���� ���� ����Ѵ�. �������� ���� ��쿡�� sal���� ����Ѵ�.
from emp;       

--����9-1
select ename, deptno, sal,
       LEAD(sal, 2, 0) over(order by sal) "next_sal",
       --sal���� ���� ����(2��°)���� ����Ѵ�. �������� ���� ��쿡�� 0���� ����Ѵ�.
       LEAD(sal, 2, sal) over(order by sal) "next_sal2"
       --sal���� ���� ����(2��°)���� ����Ѵ�. �������� ���� ��쿡�� sal���� ����Ѵ�.
from emp; 

--����10 ����̸�, �μ���ȣ, ����(�޿�), ������ ���� ����(�޿�)�� ��ȸ
select ename, deptno, sal,
       LAG(sal, 1, 0) over(order by sal) "prev_sal1",
       --sal���� ���� ���� ����Ѵ�. �������� ���� ��쿡�� 0���� ����Ѵ�.
       LAG(sal, 1, sal) over(order by sal) "prev_sal2",
       --sal���� ���� ���� ����Ѵ�. �������� ���� ��쿡�� sal���� ����Ѵ�.
       LAG(sal, 1, sal) over(partition by deptno order by sal) "prev_sal3"
       -- �̰�쿡�� 10-1���� Ȯ��
from emp;       

--����10-1 ����̸�, �μ���ȣ, ����(�޿�), ������ ���� ����(�޿�)�� ��ȸ
select ename, deptno, sal,
       --LAG(sal, 1, 0) over(order by sal) "prev_sal1",
       --LAG(sal, 1, sal) over(order by sal) "prev_sal2",
       LAG(sal, 1, sal) over(partition by deptno order by sal) "prev_sal3"
       --�μ���ȣ���� �׷����� ������ �Ŀ� �μ���ȣ�� ���� �޿��� ����Ѵ�.
       --�����޿��� ���� ��� ���簪���� �����Ѵ�.
from emp
order by deptno;       

--11. 30�� �μ������� �̸�, �޿�, �Ի���, �ش��� �� �޿��� ���� ���� ����� �Ի����ڸ� 
--�� �࿡ ��ȯ�Ѵ�.
select ename, sal, hiredate,
       LAST_VALUE(hiredate) over (order by sal
                                  rows between unbounded preceding
                                  and unbounded following) as lv
--�޿��߿��� ó������ ������ ���� �����ϴµ� �μ���ȣ�� 30�� ��쿡
--�⏋�� �ϴµ� �� �������� ���� �Ի�����(hirdate) ���� ������ ����Ѵ�.
from emp
where deptno=30;

--11-1.
select ename, deptno, sal, hiredate,
       LAST_VALUE(hiredate) over (order by sal) as lv
       --�޿��� ������ ������������ �����ϴµ� ���� ���� ���ð��
       --���߿� ������ �Ի����ڸ� ����Ѵ�.
from emp
where deptno=30;

--����12 ���� ����� Ȯ���Ѵ�.
select ename, sal, hiredate,
       FIRST_VALUE(hiredate) over(order by sal 
                     rows between unbounded preceding --unbounded�� ������ ������ ù��° �����
                     and unbounded following) as lv1, --������ ������� �����Ϳ��� ù��° �����͸� ����ϴ� ���̴�.
       FIRST_VALUE(ename) over(order by sal desc 
                     rows between unbounded preceding --unbounded�� ������ ������ ù��° �����
                     and unbounded following) as lv2 
                     --������ ������� �޿� �����Ϳ��� ù��° �̸��� ����ϴ� �����̴�. 
from emp
where deptno = 30;                     

--����12-1 12������ �и��ؼ� ����� ���� ����� ���� �˼� �ִ�.
select ename, sal, hiredate,
       FIRST_VALUE(hiredate) over(order by sal --FIRST_VALUE(hiredate)�� ó�� �Ի������� ��
                     rows between unbounded preceding --unbounded�� ������ ������ ù��° �����
                     and unbounded following) as lv1 
                     --������ ������� �����Ϳ��� ù��° ������ �Ի����ڸ� ����ϴ� ���̴�.
from emp
where deptno = 30;                     

--����12-2
select ename, sal, hiredate,
       FIRST_VALUE(ename) over(order by sal desc --FIRST_VALUE(ename)�� �޿��� �������� ������ ó�� �̸��� ��
                     rows between unbounded preceding --unbounded�� ������ ������ ù��° �����
                     and unbounded following) as lv2 
                     --������ ������� �޿� �����Ϳ��� ù��° �̸��� ����ϴ� �����̴�. 
from emp
where deptno = 30;                     
