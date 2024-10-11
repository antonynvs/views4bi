use db_atividade_view;

-- 1. Exibir lista de alunos e seus cursos
--  Crie uma view que mostre o nome dos alunos e as disciplinas em que estão matriculados, incluindo o nome do curso

CREATE OR REPLACE VIEW lista_alunos_cursos AS
select aluno.nome na, disciplina.nome nd, curso.nome nc
from aluno 
inner join matricula on matricula.id_aluno = aluno.id_aluno
inner join disciplina on disciplina.id_disciplina = matricula.id_disciplina
inner join curso on curso.id_curso = disciplina.id_curso;

-- 2
-- Crie uma view que mostre o nome das disciplinas e a quantidade de alunos matriculados em cada uma.

CREATE OR REPLACE VIEW lista_quantidade_alunos AS
select disciplina.nome disciplina_nome, count(matricula.id_aluno) as quantidade_alunos
from disciplina
left join matricula on disciplina.id_disciplina = matricula.id_disciplina
group by disciplina.nome;

-- 3
-- Crie uma view que mostre o nome dos alunos, suas disciplinas e o status da matrícula (Ativo, Concluído, Trancado).

CREATE OR REPLACE VIEW lista_status AS
select aluno.nome nome_aluno, disciplina.nome nome_disciplina, matricula.status 
from aluno
inner join matricula on matricula.id_aluno = aluno.id_aluno
inner join disciplina on disciplina.id_disciplina = matricula.id_disciplina;

-- 4
-- Crie uma view que mostre o nome dos professores e as disciplinas que eles lecionam, com os horários das turmas.

CREATE OR REPLACE VIEW lista_professor_horario AS
select professor.nome nome_professor, disciplina.nome nome_displina, turma.horario
from professor
inner join turma on turma.id_professor = professor.id_professor
inner join disciplina on disciplina.id_disciplina = turma.id_disciplina;

-- 5. Exibir alunos maiores de 20 anos
-- Crie uma view que exiba o nome e a data de nascimento dos alunos que têm mais de 20 anos.

CREATE OR REPLACE VIEW lista_maiores_vinte AS
select aluno.nome, aluno.data_nascimento
from aluno
where  datediff(curdate(), data_nascimento) / 365 > 20;

-- 6. Exibir disciplinas e carga horária total por curso
-- Crie uma view que exiba o nome dos cursos, a quantidade de disciplinas associadas e a carga horária total de cada curso.

CREATE OR REPLACE VIEW cursos_disciplinas_carga as
select curso.nome as nome_curso, count(disciplina.id_disciplina) as quantidade_disciplinas, sum(curso.carga_horaria) as carga_horaria_total
from curso
left join disciplina on curso.id_curso = disciplina.id_curso
group by curso.nome;

-- 7. Exibir professores e suas especialidades
-- Crie uma view que exiba o nome dos professores e suas especialidades.

CREATE OR REPLACE VIEW professor_especialidade as
select professor.nome, professor.especialidade
from professor;

-- 8. Exibir alunos matriculados em mais de uma disciplina
-- Crie uma view que mostre os alunos que estão matriculados em mais de uma disciplina.

CREATE OR REPLACE VIEW mais_disciplinas as
select aluno.nome, aluno.id_aluno, count(matricula.id_disciplina) as quantidade_disciplinas
from aluno
inner join matricula on matricula.id_aluno = aluno.id_aluno
group by aluno.nome, aluno.id_aluno
having count(matricula.id_disciplina) > 1;

-- 9. Exibir alunos e o número de disciplinas que concluíram
-- Crie uma view que exiba o nome dos alunos e o número de disciplinas que eles concluíram

CREATE OR REPLACE VIEW disciplinas_concluidas as
select aluno.nome, count(matricula.id_disciplina) as disciplinas_concluidas 
from aluno
left join matricula on matricula.id_aluno = aluno.id_aluno
where matricula.status = "Concluído"
group by aluno.nome;

-- 10. Exibir todas as turmas de um semestre específico
-- Crie uma view que exiba todas as turmas que ocorrem em um determinado semestre (ex.: 2024.1).

CREATE OR REPLACE VIEW semestre_especifico as
select turma.semestre
from turma
where turma.semestre = "2024.1";

-- 11. Exibir alunos com matrículas trancadas
-- Crie uma view que exiba o nome dos alunos que têm matrículas no status "Trancado".

CREATE OR REPLACE VIEW matricula_concluida  as
select aluno.nome, matricula.status
from aluno
inner join matricula on matricula.id_aluno = aluno.id_aluno
where matricula.status = "Trancado"
group by aluno.nome;

-- 12. Exibir disciplinas que não têm alunos matriculados
-- Crie uma view que exiba as disciplinas que não possuem alunos matriculados.

CREATE OR REPLACE VIEW disciplinas_sem_alunos AS
select disciplina.id_disciplina, disciplina.nome, disciplina.descricao, disciplina.id_curso
from disciplina 
left join matricula on disciplina.id_disciplina = matricula.id_disciplina and matricula.status = 'Ativo'
where matricula.id_matricula is null;

-- 13. Exibir a quantidade de alunos por status de matrícula
-- Crie uma view que exiba a quantidade de alunos para cada status de matrícula (Ativo, Concluído, Trancado).

CREATE OR REPLACE VIEW alunos_por_status AS
select matricula.status, count(*) as quantidade_alunos
from matricula
group by matricula.status;


-- 14. Exibir o total de professores por especialidade
-- Crie uma view que exiba a quantidade de professores por especialidade (ex.: Engenharia de Software, Ciência da Computação).

CREATE OR REPLACE VIEW professor_especialidade AS
select professor.especialidade, count(*) as qtd_professor_especialidade
from professor
group by professor.especialidade;

-- 15. Exibir lista de alunos e suas idades
-- Crie uma view que exiba o nome dos alunos e suas idades com base na data de nascimento.

CREATE OR REPLACE VIEW idade_alunos AS
select nome, TIMESTAMPDIFF(year, data_nascimento, curdate()) AS idade
from aluno;


-- 16. Exibir alunos e suas últimas matrículas
-- Crie uma view que exiba o nome dos alunos e a data de suas últimas matrículas.

CREATE OR REPLACE VIEW ultima_matriculaa AS
select aluno.nome AS nome_aluno, MAX(matricula.data_matricula) AS ultima_matricula
from aluno 
join matricula on aluno.id_aluno = matricula.id_aluno
group by aluno.nome;


-- 17. Exibir todas as disciplinas de um curso específico
-- Crie uma view que exiba todas as disciplinas pertencentes a um curso específico, como "Engenharia de Software".

CREATE OR REPLACE VIEW disciplinas_especificas AS
select disciplina.nome AS nome_disciplina
from disciplina 
join curso on disciplina.id_curso = curso.id_curso
where curso.nome = 'engenharia de software';

-- 18. Exibir os professores que não têm turmas
-- Crie uma view que exiba os professores que não estão lecionando em nenhuma turma.

CREATE OR REPLACE VIEW professores_sem_turma AS
select professor.nome AS nome_professor
from professor 
left join turma on professor.id_professor = turma.id_professor
where turma.id_turma is null;

-- 19. Exibir lista de alunos com CPF e email
-- Crie uma view que exiba o nome dos alunos, CPF e email.

CREATE OR REPLACE VIEW nome_cpf_email AS
select aluno.nome, aluno.cpf, aluno.email
from aluno;

-- 20. Exibir o total de disciplinas por professor
-- Crie uma view que exiba o nome dos professores e o número de disciplinas que cada um leciona.

CREATE OR REPLACE VIEW professores_nm_disciplinas AS
select professor.nome as nome_professor, count(turma.id_disciplina) as mero_disciplinas
from professor 
left join turma on professor.id_professor = turma.id_professor
group by professor.nome;


