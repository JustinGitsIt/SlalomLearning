### This tutorial is to help _Builders get the hang of dbt, how it works, and provide some Fishtown repos to help get your project off the ground quickly

### Prerequisites
* docker
* docker compose
* git
* dbt - https://docs.getdbt.com/dbt-cli/installation/

### Docker Instructions

1. Spin up the containers in detached mode
```sh
$ docker-compose up -d
```

2. Shell to the dbt container
```sh
$ docker exec -it dbt /bin/bash
```


### Connecting directly to the database

* Running `psql` on the postgres container
```sh
$ docker exec -it pg psql -U postgres
```

* Running *`psql` from the host container
    * `~/.pgpass` is the awesome, normally I would use that, but 
     for the purposes of this demo temporarily point to a different location for it, because the real one contains secrets
    * needs chmod 600
    * The `docker-compose` file maps ports 5433:5432 because you may already be using the default port on your host. I know I am.
```sh
$ export PGPASSFILE='.pgpass' psql -h localhost -p 5433 -U postgres
```



### Getting started with dbt
----------------------------------------


### What is dbt

dbt stands for data build tool. It is an open source packaged software that was created by Fishtown Analytics. God bless them. 

dbt’s main function is to act as a development environment for you to work with the language of data analytics… wait for it… SQL! 

It is built upon Python and heavily relies on Python’s Jinja template library. It gives devs the amazing power to write templates that can generate SQL on the fly. You can now save time by building jinja templates to build your SQL queries. All you need to do is pass in the needed variables and these SQL queries will be built for you. You can easily create SQL for an entire database in minutes.



### Building a database transformation codebase with dbt

Fishtown gives a lot of useful tools for devs to use to expedite their warehouse build. If you are curious check them out here: https://github.com/fishtown-analytics/dbt-codegen

Yaml is dbt’s jam. dbt pretty much runs off your yaml configurations. You can loosely couple you’re E, L and T by messing with your dbt_project.yml and the source yaml files. This is immensely powerful because it allows you to be agnostic on what your sources are and gives you great flexibility on building your Ts.
In the repo above you can find a macro called generate_source.sql. This will look in the profiles.yml that is created when you initially start your dbt project and pop out the source tables, columns, and any other meta data you may want to include (note you will need to refactor some to do so) from the database in your yaml. You can now start to build your staging area!

If you go back to the handy dandy repo they have another wonderful macro, generate_base_model.sql. You can run this macro with the source yaml you just created as the input, and BAM, your staging environment is created. If you have a specific schema you would like this to live or a certain materialization, you can adjust this in your dbt_project.yml.  

NOTE: if data type conversions or table calculations need to happen make it happen in the staging area.

When building out your models we want to make sure to only reference sources once, in the staging environment, and then only reference models as you move downstream in your data model. You can look in models/marts/core/intermediate to see how the dependencies are built upon the previous set of models. These tables use the stage tables just created as the sources for the queries.

This is because it allows you to only have to make changes in one place in a source and those changes are automatically applied to your downstream models that reference that source

When you get ready to built the presentation layer dbt best practice is to create an intermediate staging area. In this area staging tables are joined into larger wider tables that will be used as the main building blocks for your presentation layer tables (facts and dims). This is also the area you want to start adding in any calculations or special business logic before


### Finishing up codebase build

dbt give various ways to materialize your data. They can be set as tables, views, ephemeral tables, etc., please feel free to read more about these and their advantages and disadvantages here: https://docs.getdbt.com/docs/building-a-dbt-project/building-models/materializations

There is a ton of information that this read me does not go over. There are seed tables, built in tests, yaml configs and other fun tools too, so please feel free to peruse their robust documentation: https://docs.getdbt.com/docs/introduction


### Running your dbt project in bash
 
 It is really easy to run dbt. There are really only two commands that you need to deploy your project to the target database defined in your profiles.yml
 
```
dbt compile  #compiles the code to check for errors

dbt run  #deploys it to your target database

#Drink a beer (or favorite beverage) and watch the magic happen
```

You can now open your postgres database that was created at the beginning of this tutorial to see all of the models have been deployed. Feel free to change some of the materializations in your dbt_project.yml and dbt run it all again to see how they change in your database.


### BUT WAIT THERE’S MORE!

If you run:
```
dbt docs generate  #compiles a static HTML file using the node and graph the dbt project creates in the dbt compile command

dbt docs serve  #locally hosts the HTML file
```

dbt will generate a static HTML page and host a rich documentation site that catalogs your whole project, shows how models are referenced, and displays any documentation you want to include. You can find it under target/index.html There is also an opportunity to host these sites on an S3 bucket or have dbt Cloud host it if you would like it to be available to others. 

The dbt site has a lot to offer, so look at some of the features on this page: https://docs.getdbt.com/docs/building-a-dbt-project/documentation/

Note worthy features are: the directory lay out of the project, overview of tables and its associated code that is in jinja and its compiled formats, and the data lineage graph for each table

dbt takes a huge problem for a lot of companies and makes it easy if you build your development workflow to incorporate documentation as you develop. They give the ability to have a living and versionalbe data dictionary and documentation site. Pretty cool, huh?



### Noteworthy sites and repo

- Read the introduction to dbt:(https://dbt.readme.io/docs/introduction).
- dbt Utils: (https://github.com/fishtown-analytics/dbt-utils/tree/dev/0.6.0/macros) this repo has a lot of common macros that you can use to help speed up the development of your project

- dbt code-gen: (https://github.com/fishtown-analytics/dbt-codegen) this repo contains macro to get your project off the ground quickly and create yamls for your data definintions and macros to dynamically build out models based on yaml inputs

- dbt audit-helper: (https://github.com/fishtown-analytics/dbt-audit-helper) this repo has macros that will build models that can help you do some data profiling and build out parity tests that can be used to compare new features to your current environment and see what happens to the data

