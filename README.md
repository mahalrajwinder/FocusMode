# FocusMode Study App

## Introduction

One of the main goals of a college education is learning how to solve problems and manage yourself on your own. And while this seems to be exciting, balancing your free time with study time is one of the most common challenges among college students. For example, one of the most common excuses among college students for not completing their homework is that they procrastinate until the last minute of the due date and end up not having enough time to finish the assignment. Another common reason among students for not finishing their assignments on time is distractions that occur during their study time. For example, most of the students keep their phones next to them while they study. So, if a notification pops up, it is extremely difficult for them to not pick up their phone unless there is someone to stop them.

Both procrastination and distractions during study time could attribute to their overall stress, thereby resulting in poor understanding of concepts and a higher risk of failing the class. To help students overcome these common yet challenging problems, we are developing an iOS app named **FocusMode**. Our app will track their [college students] pending tasks as well as their study habits to help them effectively manage their time. The goal of the app is to recommend its users for a particular place and time to work on a particular task to ensure that they finish all their assigned tasks before the due date while creating a balance between their personal life and study time.

## Building the Personal Model

Foremost to describing the procedure of building the user model, it is essential to clarify that two different types of user models are constructed. The first is a static user model build using the Explicit Modeling Approach, meaning by asking the user directly. The second is a dynamic user model that is built using both Explicit and Implicit Modeling Approach and uses a learning algorithm to modify the model as the user interacts with the system.

The outline of our approach to build a personal model consists of three steps:
1. The content-based static user model construction step.
2. The user’s neighborhood formation step.
3. The hybrid (using both content-based and collaborative filtering approach) dynamic user model construction step.
------

1. **Building a Static User Model**

We will construct a static user model once the user registers with the system, and is never modified unless the user explicitly updates his/her profile information. The first type concerns demographic data, while the second type deals with preference data. The third type deals with individual evaluations and includes asking questions whose answers are given as percentages.

For each user, the collected demographic data includes a user’s name, age, gender, height, weight, physical address, and academic major. The preference data includes a user’s preferred time of study (morning, afternoon, evening), daily goal (meaning how much the user wants to study/work daily), and preferred bedtime.

The individual evaluation questions include how often the user meets the given deadlines, how hardworking the user is, and how quickly does the user adjust to changing priorities.

With the completion of this step, a static user model is formed that acts as an input for finding the user's neighborhood (described below) and then building a dynamic user model.

2. **The User’s Neighborhood Formation step**

Following the formation of the static user model, a user’s neighborhood is constructed. Whenever a new user registers with the system, his or her static user model (constructed in the previous step) is used to find the user’s neighborhood, that is finding users that have similar demographics and preferences. For each data field in the static user model, we create a list of users that have similar values/preferences for that field. Once we have that, each user in each ranked list is assigned a weighted value (data field importance * relative rank in the ranked list). Once we do this for each ranked list for every data field, we combine all the ranked lists and sort them based on weighted value. Then, the top 10 users are used as the user’s neighborhood.

With the completion of this step, a user’s neighborhood is formed that acts as an input for building a dynamic user model in the next step.

3. **Building a Dynamic User Model**

Following the formation of the user's neighborhood, a dynamic user model is constructed. Whenever a new user registers with the system, his or her static user model (constructed in the previous step) is used to find the user's neighborhood, that is finding users that have similar demographics and preferences. Then, dynamic models of the user's neighborhood are used to create an initial dynamic user model for the newly registered user. For details on how we find a user’s neighborhood, see The user’s neighborhood formation step in the previous step.

The model consists of number of tasks created and completed by the user, an index of days (ranked list of days of week based on user logs and study activity), range of average temperatures (reset to average at the end of each month), and activity (how much the user has worked on a given day; reset to 0 at midnight). Additionally, the model consists of a ranked list of places where the user has worked/studies in the past. Each place in the ranked list contains information such as coordinates of the place, user’s ratings for that place, count of how many times the user has worked/studies at that place, and a log of all types of tasks the user has worked on, at that place. The log contains the frequency of each task worked at that place, along with the amount of time spent, and the number of distractions. Such information is used to calculate the user productivity for a given task relative to the place.

Moreover, the model keeps a log of all the tasks ever created by the user. Each log entry consists of raw priority of the task, actual time spent on the task and the total time it took to complete the task (includes time lag), number of distractions faced, number of breaks taken by the user, and whether the user was able to complete it on time or not. These logs are used for calculating priority and start by date (latest date by which the user should start working on the task to complete it on time).

----

## Making Recommendations

Following the formation of a personal model (static and dynamic user model), the system can provide recommendations to the users. The types of recommendations provided are listed below:

1. Recommending Tasks
2. Recommending Places for a given task
3. Recommendations through Smart search for nearby places
4. Recommendations through Notifications
