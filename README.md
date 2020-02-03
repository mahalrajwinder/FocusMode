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
| age            | Int      | user's age |
| height         | Double   | user's height in centimeters |
| weight         | Double   | user's weight in pounds |
| gender         | String   | user's gender identity |
| timePreference | String   | whether the user wants to work/study in the morning or evening |
| bedtime        | String   | user's bedtime { HH:MM AM/PM } |
| major          | String   | user's academic major |
| dailyGoal      | String   | how many minutes the user wants to work/study daily |
| deadlineSuccessRate | Double | how often the user meets the given deadlines. Ranges between 0 and 1 |
| handlingPriorities  | Double | user's ability to adjust to changing priorities. Ranges between 0 and 1 |
| tasksCreated   | Int      | total number of tasks ever created by the user |
| tasksCompleted | Int      | total number of tasks ever completed by the user |
| rankedDays     | [String] | array of days of weeks ranked based on user's productivity on each day |
| mostVisitedPlaces | [(latitude, longitude)] | array of coordinates of user's most visited places. Maximum 10 places |
