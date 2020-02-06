# FocusMode
One of the most common excuses among students for not completing assignments is that they get distracted while studying. This distraction can be stressful and can lead to a poor understanding of concepts. Thus, we come up with an iOS app, called FocusMode, that helps students not only concentrate better while studying, but helps them improve their long-term study habits.

FocusMode continuously tracks the study habits of its users and then builds a personal model to improve their study habits by recommending them for personalized study sessions, including the most suitable place to study.

## Models

#### User
| Property       | Type     | Description |
| -------------- | -------- | ------------|
| uid            | String   | user's unique identifier |
| email          | String   | user's email |
| password       | String   | user's password |

#### User Profile
| Property       | Type     | Description |
| -------------  | -------- | ------------|
| uid            | String   | user's unique identifier |
| name           | String   | user's full name |
| age            | Number   | user's age |
| height         | Number   | user's height in centimeters |
| weight         | Number   | user's weight in pounds |
| gender         | String   | user's gender identity |
| timePreference | String   | whether the user wants to work/study in the morning or evening |
| bedtime        | String   | user's bedtime { HH:MM AM/PM } |
| major          | String   | user's academic major |
| dailyGoal      | Number   | how many minutes the user wants to work/study daily |
| activity       | Number   | tracks user's daily activity (how much user studies so far). Resets to 0 at midnight |
| deadlineSuccessRate | Number | how often the user meets the given deadlines { between 0 and 1 } |
| handlingPriorities  | Number | user's ability to adjust to changing priorities { between 0 and 1 } |
| tasksCreated   | Number      | total number of tasks ever created by the user |
| tasksCompleted | Number      | total number of tasks ever completed by the user |
| rankedDays     | [Number]    | array of days of weeks ranked based on user's productivity on each day |
| mostVisitedPlaces | [(latitude, longitude)] | array of coordinates of user's most visited places. Maximum 10 places |

#### Task

1. **Todo**

| Property       | Type     | Description |
| -------------  | -------- | ------------|
| tid            | String   | task's unique identifier |
| title          | String   | task's title / short description |
| dueDate        | String   | task's due date |
| category       | String   | type of task { Homework, Exam, Quiz, Project, Other } |
| subject        | String   | task's academic subject { Science, Mathematics, Computer Science / Engineering, English / Writing, Social Studies, General / Other } |
| priority          | Number | task's importance. Lowest number represents the highest priority |
| predictedDuration | Number | how long would user take to complete the task |
| totalBreaks       | Number | how many breaks user took to complete the task |
| breakDuration     | Number | total break time user took while working on the task |
| totalDistractions | Number | how many times the user got distracted while working on the task |
| start             | String | when did the user start working on the task |
| temperatureRange  | Number | minimum and maximum temperature in Fahrenheit for working on the task |
| suitedLocations   | Coordinates | location coordinates of places where user should work on the task |

2. **Completed**

| Property       | Type     | Description |
| -------------  | -------- | ------------|
| tid            | String   | task's unique identifier |
| title          | String   | task's title / short description |
| dueDate        | String   | task's due date |
| category       | String   | type of task { Homework, Exam, Quiz, Project, Other } |
| subject        | String   | task's academic subject { Science, Mathematics, Computer Science / Engineering, English / Writing, Social Studies, General / Other } |
| priority          | Number | task's importance. Lowest number represents the highest priority |
| observedDuration  | Number | Actual time user took to complete the task |
| totalBreaks       | Number | how many breaks user took to complete the task |
| breakDuration     | Number | total break time user took while working on the task |
| totalDistractions | Number | how many times the user got distracted while working on the task |
| start             | String | when did the user start working on the task |
| end               | String | when did the user stop working on the task (complete or incomplete) |
| status            | Number | Whether the task is completed or not { 1 means completed, 0 means not } |
| ratings           | Number | user's ratings to the task { between 0 and 10 } |
| temperature       | Number | average temperature in Fahrenheit while the user was working on the task |
| location     | Coordinates | location coordinates where most of the task was completed |
