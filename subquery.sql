-- # �������� p.153

-- ## ���� �� �������� 

-- p.157
-- ����1) 7566�� ������� �޿��� ���� �޴� ����� �̸�, �޿��� ��ȸ�϶� 
select ename, job
from emp
where job = (select job from emp where empno=7566);
-- where���������� ���������� �� job�� ���� �Ŀ� 
-- ���� ������ job�� ���Ͽ� ������ ���
            
-- ����2) EMP ���̺��� �����ȣ�� 7521�� ����� ������ ����, 
-- �޿��� 7934�� ������� ���� ����� �����ȣ, �̸�, ������, �Ի�����, �޿��� ��ȸ�϶�
select empno, ename, job, hiredate, sal
from emp
where job = (select job
             from emp
             where empno=7521)
AND sal > (select sal
           from emp
           where empno=7934);

-- ����3) EMP ���̺��� �޿��� ���� ���� �޴� ����� �̸�, �μ���ȣ, �޿�, �Ի����� ��ȸ�϶�
-- �޿��� ���� ���� �޴� ����---> �ִ밪
select ename, deptno, sal, hiredate
from emp
where sal = (select MAX(sal) from emp);
-- �޿��� �ִ밪�� �ش��ϴ� ����� �̸�, �μ���ȣ �޿�, �Ի����ڸ� ���             
-- �޿��� �ִ밪�� ���ϴ� ���� select MAX(sal) from emp;

select ename, deptno, sal, hiredate
from emp
where sal = max(sal);
-- �׷��Լ��� �������� ����Ҷ� having���� ����ؾ� �ȴ�.
-- where ���������� �׷��Լ��� ����ϸ� �ȵȴ�.

--����4) EMP ���̺��� �޿��� ��պ��� ���� ����� 
-- �����ȣ, �̸�, ��� ����, �޿� , �μ���ȣ�� ����Ͽ���
select empno, ename, job, sal, deptno
from emp
where sal < (select ROUND(AVG(sal))from emp);
--�޿��� ��հ����� ���� �����ȣ, �̸�, �μ�, �޿�, �μ���ȣ�� ��� 
--�޿��� ��հ��� ���ϴ� ���� select ROUND(AVG(sal)) from emp;

--����5) EMP ���̺��� ����� �޿��� 20�� �μ��� �ּ� �޿����� ���� �μ��� ��ȸ�϶�
-- �μ���ȣ�� 20���� �ּұ޿����� ū ���� ���� �ٸ� �μ��� �μ���ȣ�� �ּҰ��� ����Ͻÿ�

--�μ���ȣ�� 20���� �ּұ޿��� �����ϴ� ����
select MIN(sal) from emp
where deptno=20;

select deptno, min(sal)
from emp
group by deptno
having min(sal) > (select MIN(sal) from emp where deptno=20);

-- ## ������ ��������

-- p159 
-- ����1) ���� ������ ����� Ȯ���Ѵ�.
select empno, ename, sal, deptno
from emp
where sal = (select MAX(sal) from emp group by deptno);
-- �����߻��� ������ '=' �����ڿ����� 1�� ���� ���ϱ�  ������ �����߻�.
select MAX(sal)
from emp
group by deptno;             
-- �� ��°��� �������� �����µ�  '=' �����ڿ����� 1�� ���� ���Ѵ�.

-- �ذ���
select empno, ename, sal, deptno
from emp
where sal IN (select MAX(sal)
             from emp
             group by deptno);
--sal���� 10�� �μ���ȣ�� �ִ밪 5000�Ǵ�
--sal���� 20�� �μ���ȣ�� �ִ밪 3000�Ǵ�
--sal���� 30�� �μ���ȣ�� �ִ밪 2850�� ���� ���� ���

--����2) ������ 'SALESMAN'�� �ּ� �� �� �̻��� ������� �޿��� ���� �޴� ����� �̸�,�޿�,������ ��ȸ
-- (�ٸ��� �ؼ��ϸ� ������ 'SALESMAN'�� �ּ� �޿����� ���� �޴� ���)
-- 'SALESMAN'�� �޿�
select sal 
from emp
where job='SALESMAN';
--job�� 'SALESMAN'�� ������� �޿��� ����Ѵ�.

select ename, sal, job
from emp
where job != 'SALESMAN'
AND sal > (select MIN(sal) 
           from emp
           where job='SALESMAN');
-- sal���� ������ 'SALESMAN'�� �ּ� �޿����� ���� �޴°�

-- ANY������ ����tp          
select ename, sal, job
from emp
where job != 'SALESMAN'
AND sal > ANY (select sal 
           from emp
           where job='SALESMAN');
-- sal���� �߿��� �ּҰ� ���� ū ���� ���           
           
--����3)������ 'SALESMAN'�� ��� ������� �޿��� ���� �޴� ����� �̸�,�޿�, ����, �Ի���, �μ���ȣ�� ��ȸ�϶�
--(�ٸ��� �ؼ��ϸ� ������ 'SALESMAN'�� ��� ����� �ִ밪���� ū��)
select ename, sal, job, hiredate, deptno
from emp
where job != 'SALESMAN'
AND sal > ALL (select sal 
           from emp
           where job='SALESMAN');
--ALL�� job�� 'SALESMAN'�� ������� ��� �޿���� ������ 
--��� �޿����� ũ�ٴ� ���� job�� 'SALESMAN'�� ������� �ִ밪�� �ȴ�.

--���� 3-1
select ename, sal, job, hiredate, deptno
from emp
where job != 'SALESMAN'
AND sal > (select MAX(sal) 
           from emp
           where job='SALESMAN');

-- ## ���� �� ��������
-- 2�� �̻��� �÷��� ���� ������ �ش�.

-- p126
--���� 1) FORD, BLAKE�� ������ �� �μ��� ���� ����� ���� ��ȸ�� ��ȸ�ϴ�
--FORD�� ������ �� �μ�
select mgr, deptno
from emp
where ename = 'FORD';
--����� ��� : 7566   20

select mgr, deptno
from emp
where ename = 'BLAKE';
--����� ��� : 7839   30

select ename, mgr, deptno
from emp
where MGR IN (select mgr 
              from emp
              where ename IN('FORD','BLAKE'))
AND deptno IN(select deptno 
              from emp
              where ename IN('FORD','BLAKE'))
AND ename NOT IN('FORD','BLAKE');
--��°���� ������ �ٸ��� ��µȴ�.
--(7566,20) �Ǵ� (7839,30)�� ��µǾ�� �ϴµ�
--�� ������ ��°���� 
--JONES	7839	20
--SCOTT	7566	20
--SCOTT	7566	20�� ��µǾ�� �Ѵ�.

--�׷���, PAIRWISE�������� ����� �ʿ��ϴ�.
--����2) PAIRWISE subquery ���������� ����1 ����� ���غ���.
select ename, mgr, deptno
from emp
where (MGR, deptno) IN (select mgr, deptno from emp where ename IN('FORD','BLAKE'))
AND ename NOT IN('FORD','BLAKE');
-- 7566�� 20�� ���� 7839�� 30�� �����͸� ����ϴµ� ���ǿ� �´°���
--����� : SCOTT	7566	20 �̴�.

-- ��ȣ ���� ���� ����
-- ���������� ���� ���������� �Ѱ��ְ�, ���� ������ ������
-- �Ŀ� �� ����� �ٽ� ���������� ��ȯ�ؼ� �����ϴ� ���̴�.
-- p162

-- ����1) �ҼӺμ��� ��� �޿����� ���� �޿��� �޴� ����� �̸�, �޿�
--,�μ���ȣ, �ӻ���, ���� ������ ��ȸ
select deptno, ROUND(AVG(sal))
from emp
group by deptno;

--����
select ename, sal, deptno, hiredate, job
from emp ME
where sal > (select AVG(sal)
             from emp SE
             where SE.deptno = ME.deptno);
--�������� ���̺��� ��Ī�� ME, �������� ���̺��� ��Ī�� SE�� ����
--������������ 1���� ������(���ڵ�)�� �о ����������
--����ȣ ME.deptno���� ���� �Ѱ��ش�.
--���������� ���������� �μ���ȣ�� ���� ������ ��� �޿��� ������
--�ٽ� ���� ������ ���������� ��� �޿����� ū �޿��� ������ ���
--���� �ð��� ���� �ҿ��(2�� for���� ���� �ð��� �ҿ��)
--��ü ���� 14�� �̱� ������ 14*14�� �ݺ��ϰ� �ȴ�.

-- FROM�� ��������
-- FROM�� ���������� �ζ��� ��(inline view)��� �Ѵ�.
-- ��ȣ�������� ���氡���� ��쿡�� inline view �� ������ �� ����
-- inline view �ݵ�� alias ����
-- p166

--����1) ���� �������� Ȯ���Ѵ�.
-- from �� ��������1
select * from emp where deptno=10;
--�� ����� 
--7782	CLARK	MANAGER	7839	11/01/09	2450		10
--7839	KING	PRESIDENT		91/11/17	5000		10
--7934	MILLER	CLERK	7782	20/01/23	1300		10
--�� ���̺� ��Ī�� e�� �����Ѵ�.

-- from �� ��������2
select * from dept;
--���
--10	ACCOUNTING	A1
--20	RESEARCH	B1
--30	SALES	C1
--40	OPERATIONS	A1
--50	INSA	
--�� ��Ī�� d�� �Ѵ�.

select e.empno, e.ename, e.deptno, d.dname, d.loc_code
from (select * from emp where deptno=10) e,
     (select * from dept) d
where e.deptno = d.deptno;     
--e ���̺�� d ���̺��� �μ���ȣ�� ���� �͸� ����Ѵ�.

-- TOP-N ��������
-- p168
-- �����÷�(peseudo column)
-- ����1)
select ROWNUM, empno, ename, sal --����° ����
from emp --ù��° ����
where ROWNUM < 4;--�ι�° ����
--emp���̺� �ִ� �����͸� �о select������
--ROWNUM�� �Ϸ��� ��ȣ�� ���δ�.
--ROWNUM���� 4���� ���� �͸� ����Ѵ�.
--��°��
--1	7369	SMITH	800
--2	7499	ALLEN	1600
--3	7521	WARD	1250
select ROWNUM, empno, ename, sal --����° ����
from emp --ù��° ����
where ROWNUM < 4--�ι�° ����
order by sal desc; --�׹�° ����
--��°��
--2	7499	ALLEN	1600
--3	7521	WARD	1250
--1	7369	SMITH	800

--����2
select ROWNUM, empno, ename, sal
from (select empno, ename, sal
      from emp
      order by sal desc)
where ROWNUM < 4;
--from���� sal���� �������� ������������ ������ ���̺��� ������
--ROWNUM���� �ο��Ѵ�.
--��°��
--1	7839	KING	5000
--2	7788	SCOTT	3000
--3	7902	FORD	3000

--171page
--��Į�� ��������
--�ϳ��� �࿡�� �ϳ��� �÷� ���� ��ȯ�ϴ� ���������� ��Į�� ����������� �Ѵ�.

--����1 CASE ǥ���Ŀ� ��Į�� ���������� ����Ѵ�.
select empno, ename, deptno,
       (case when deptno=(select deptno from dept where loc_code='B1')
             then 'TOP' else 'BRENCH' end) as location
from emp;
-- deptno���� ���������� loc_code���� 'B1'�� �������� �μ���ȣ(deptno)�� ���� ��쿡
-- 'Top'�� ����ϰ�, �ٸ��� 'BRENCH'�� ����Ѵ�.

--����2. ����̸�, �μ���ȣ, �޿�, �ҼӺμ��� ��տ����� ��ȸ�϶�
select empno, deptno, sal,
       (select AVG(sal) from emp where deptno=e.deptno) as asal
from emp e;
-- ���� �������� �����͸� �� �� ���� �Ŀ� ��Į�� ���������� ������ ���� ��ŭ �ݺ��ؼ�
-- �μ���ȣ�� ���� ��쿡�� ����� ����Ѵ�.
-- ���� emp���̺��� �����͸� ��� ���� �Ŀ� ��°���� ���� ���� �μ���ȣ�� �����
-- ���� ��µȴ�.

--����3. ORDER BY���� ��Į�� �������� ����� ���
select empno, ename, deptno, hiredate
from emp e
order by (select dname from dept where deptno=e.deptno) desc;
--emp���̺��� �μ���ȣ�� dept���̺��� �μ���ȣ�� ���� ��쿡 dname���� ������
--���������� �ϴµ� dname���� ����Ҽ� ���� ������ 3-1�� ���� �����ؼ� ������ ����

--3-1��
select empno, ename, deptno, hiredate, 
      (select dname from dept where deptno=e.deptno) as Name
from emp e 
order by Name desc;

--EXISTS ������
-- 174������
--����1. �Ҽ� ����� �����ϴ� �μ��� �μ���ȣ, �μ��� ��ȸ�Ѵ�.
select deptno, dname
from dept d
where EXISTS (select 'A'
              from emp
              where deptno = d.deptno);
--dept���̺��� ������ �����͸� �о where��������
--���������� dept���̺��� deptno(�μ���ȣ��) �ѱ��,
--������������ emp���̺��� deptno(�μ���ȣ)�� dept���̺��� �μ���ȣ��
--���� ���� ���� ��쿡�� �� �̻� emp ���̺��� �����͸� ���� �ʴ´�.
--EXISTS�����ڴ� ���� ���� ���� ��쿡 ���������� ������ ���� �ϱ� ���ؼ�
--����ӵ��� ������Ų��. �������� 'A'�� �ٸ� ���� ����ص� �ȴ�.

--����2. ���� �������� Ȯ���Ѵ�.
select empno, ename, job, hiredate, sal, deptno
from emp e
where EXISTS (select 1
              from emp
              where e.empno = mgr)
order by empno;
--������������ emp���̺��� ������ 1���� �÷��߿��� empno����
--���������� �Ѱ��ְ�, ������������ ���������� empno�� ����������
--mgr���� ���� ��� ���������� ����ǰ� true���� �Ѱ��ش�.

--����3. �� ������ ���̺��� ��� skip

--WITH����
--176������
--���� ���� ����� ������ �����ϰų� ���� �� ���Ը� �ؾ� �ϴ� ��� �ſ� �����ϴ�
--�ش� ���� ���ǿ��� ������ �������� �ѹ��� ����ǹǷ� ������ ���ȴ�.
--����1
select deptno, sum(sal)
from emp
group by deptno
having sum(sal) > (select avg(sum(sal))
                   from emp
                   group by deptno);
--���������� �μ��� �޿��� ��ü �հ��� ����� ����ϴ� ������
--���������� �μ��� �޿����� ���������� ��պ��� ū ��� ���

--WITH ���� ����ϸ� �������ǿ��� ������ �߻��ϴ� ���� ���� ���� ����� �������
--�ӽ����̺� ����ȴ�.
--����2.
with ABC as (select deptno, sum(sal) as sum
             from emp
             group by deptno)
select *
from ABC
where sum > (select avg(sum) from ABC);