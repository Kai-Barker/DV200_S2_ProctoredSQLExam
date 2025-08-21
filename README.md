# DV200_S2_ProctoredSQLExam 

# JOINS
---
### 1 ALL RESEARCHERS WHO HAVE WORKED ON A PROJECT
---
SELECT researcher.* FROM `researcher` INNER JOIN project_researchers ON project_researchers.researcher_id = researcher.researcher_id INNER JOIN projects ON projects.project_id = project_researchers.project_id    

---
### 2 ALL PROJECTS WITH AN IN PROGRESS DELIVERABLE
---
SELECT * FROM projects LEFT JOIN project_deliverable ON project_deliverable.project_id = projects.project_id
WHERE project_deliverable.status LIKE "In Progress"

---
### 3 ALL RESEARCHERS WORKING IN A LAB
---
SELECT lab_id, researcher.* FROM `lab` INNER JOIN director ON director.director_id = lab.director_id INNER JOIN researcher ON researcher.researcher_id = director.researcher_id

# Triggers

---
### 1 Add Researcher when inserting director
---
---
### 1 Update researcher role to director
---
---
### 1 Halt a project when removing funding
---



### FIGMA BOARD LINK:
https://www.figma.com/design/r2Lu3kfyRqLjlz89DqYoN7/Exam-ER-Diagram?node-id=0-1&t=HSYre67zvnnsY8Dj-1



## WRITTEN BY KAI BARKER 241065 AND DAVID GOLDING 200238