-- DML
-- 196page

--DML�� ����
--insert : ���̺� ���ο� ���� �Է�
--update : ���̺� �ִ� ���� ����
--delete : ���̺� �ִ� ���� ����
--merge  : ���̺� �̹� �����Ͱ� �����ϸ� update, ���ο� �������̸� insert

--���̺� �� �� �߰�
--dept���̺� ����
select * from dept;
--10	ACCOUNTING	A1
--20	RESEARCH	B1
--30	SALES	C1
--40	OPERATIONS	A1
--50	INSA	

--dept���̺� ���ο� ���� �Է��Ѵ�.
--ù��° ���
insert into dept(deptno, dname, loc_code)
            values(70, 'MARKETING','B1');
--���� ���� ���� �÷��� default�� null������ �����ȴ�.
--��, Primary key�� not null�� ������ �÷��� null�� ������ �ʴ´�.

--�ι�° �����
--��� �÷��� �����͸� �Է��ϴ� ���� ���� �÷� ����Ʈ�� ������� �ʾƵ� �ȴ�.
--�׷��� ��� �÷��� �ش��ϴ� �����͸� ����ؾ� �Ѵ�.
insert into dept values(80, 'EDUCATION','C1');

--NULL ���� ���� �� ����
--�Ͻ������ : �� ��Ͽ��� ���� �����Ѵ�.
--������ loc_code�� null���� ����ȴ�.
insert into dept(deptno, dname)
       values(90, 'MIS');
select * from dept;
--Ȯ���� ���� ������ ���� �������� ���� ��쿡�� null���� ��µȴ�.
--default������ ������ ��쿡�� default���� ����ȴ�.

--����� ��� : null Ű���带 �����Ѵ�.
insert into dept(deptno, dname, loc_code)
       values(60, 'DIS', NULL);

--Ư������ ���� �� ����
--Ư������ ���� �� ����
insert into emp(empno, ename, hiredate)
       values(7233,'PAUL',sysdate);

--���� ����� �̸� �Է� : USER �Լ� �̿�
insert into emp(empno, ename, sal)
       values(7234,user,3400);

--��¥ ���� �Է��Ҷ��� TO_DATE �� ��ȯ
insert into emp(empno, ename, hiredate)
       values(7533,'ELIVAS',TO_DATE('1997-02-05','YYYY-MM-DD'));

--���������� �̿��� INSERT��
create table new_emp ( --���̺� ����
   id number(4),
   name varchar2(10)
); 

--emp���̺� ��� �̸� �߿� A�� ��� �ִ� �ÿ��� ������ new_emp���̺� �Է��Ѵ�.
--insert���� ������ ���������� ������ ��ġ�ؾ� �Ѵ�.
insert into new_emp
select empno, ename 
from emp
where ename like '%A%';

select * from new_emp;

--UPDATE��
update dept
set dname='test';
--where���� �����ϸ� ���̺��� ������� �����ȴ�.

update emp
set    deptno=20, job='CLERK';
--��� ���� deptno�� 20����, job�� 'CLERK'���� �����Ѵ�.

--where���� ����Ͽ� Ư�� ���� �����ؾ� �Ѵ�.
update emp
set    deptno = 20
where  empno = 7233;

--205������
--����1 7902 ����� �μ���ȣ�� SCOTT ����� �����ϰ� �����ϴ� update������ �ۼ�
update emp --���̺� �̸�
set    deptno = (select deptno
                 from emp
                 where ename = 'SCOTT')
where  empno=7902;                 
--empno���� 7902�� ������ �߿��� 'SCOTT'�� �μ���ȣ�� ������ �����Ѵ�.

--����2 7698�� ����� ������ 7499�� ������ �����ϰ� �μ���ȣ�� dept���̺��� SALES
--�μ��� �μ���ȣ�� ���� ��ȣ�� �����Ͻÿ�.
update emp
set    job = (select job 
              from emp
              where empno=7499), --�����ȣ�� 7499�� ����� ����(job)�� ����
    deptno = (select deptno
              from dept
              where dname='SALES') --dept���̺��� dname���� 'SALES'�� �����ȣ ���� ����
where empno=7698;

--����3 7698����� ������ �μ���ȣ�� 7499�� ����� ������ �μ���ȣ�� ������
--�����۾��� �����ϴ� update�ۼ��Ͻÿ�.
update emp
set (job, deptno) = (select job, deptno
                     from emp
                     where empno=7499) --�����ȣ�� 7499�� ����� job�� deptno���� ����
where empno=7698;                     

--�� ����
--206������
delete dept
where deptno=30;
--�λ��ȣ�� 30�� dept���̺��� �����͸� �����Ѵ�.

--����1 emp���̺��� �����ȣ 7233�� ����� �����ϴ� ����
delete emp 
where empno=7233;

--����2 SCOTT ����� ������ �μ���ȣ�� ���� ����� �����ϴ� delete�� �ۼ�
delete emp
where deptno = (select deptno
                from emp
                where ename='SCOTT');
--����3 dept���̺��� 'ACCOUNTING' �μ��� �ش��ϴ� �μ���ȣ�� �ش��ϴ�
--emp���̺��� ������ �����ϴ� delete�����̴�
delete emp
where  deptno = (select deptno
                 from dept
                 where dname = 'ACCOUNTING');