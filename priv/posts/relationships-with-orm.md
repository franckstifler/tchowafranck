---
title: Cautious one to one relationships
published: true
published_date: 2019-04-01 11:30:00
blurb: Your one to one relationship is it a one to many or really a one to one?
tags: sql, database, ecto
---

Welcome! I've been looking into implementing a maling subscription system on the blog. I'm not yet through with the implementation but very soon it will be ready. Let's dive into today's topic.

## One to One relationships
When working with web frameworks, you have usually what is called ORM (Object Relational Mapper) that handles communication with the database. Migrations files are like a version control of your database. Due to the facilities provided by ORM, we may fall into the trap of not defining properly database constraints. Is your 1-1 actually a 1-1 or a 1-*?

In other to ensure that you have a 1-1, we need to specify a unique key constraint on the foreign key. That is if you have a `student` table, and a `certificate` table, we have the following relationships: **a student has one certificate**, **a certificate belongs to a student**. Some people find it difficult to identify which of the primary keys is to migrate. The *object* that belongs to something is the one to know it's owner. So it receives the id of it's owner. On the migration file, the `student_id` migrates to the `certificate` table, referencing the `student.id` field. The unique constraint is added on the `certificate.student_id` to ensure that the student has only 1 certificate. If this is not mentioned, you will fall in cases where, you can insert certificates as many as you want for a given student, without ever receiving any error message, which is bad, and when querying you might have the first ever inserted certificate returned which is not what expected.

When you have a 1-1 relationship:
- After the first insertion, you can only `update` or `delete` the related document.
- If you're still able to insert another record, you are not having a proper 1-1 relationship and it's more like a 1-*.
- You can implement the 1-1 logic yourself, but it makes sense to use a unique constraint which makes sure that we don't have duplicates values for a given column. You can read more about it here: [unique constraint](https://www.w3schools.com/sql/sql_unique.asp)

This was what I had today for you, stay tuned!