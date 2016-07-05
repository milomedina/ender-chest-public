===가정===

1. Timeslots 테이블은 예약이 가능한 모든 시간대가 삽입되어 있다. 예를 들어 5월 25일-6월 3일 9시-18시 20분 간격으로 예약을 잡을 수 있다고 하면 5월 25일 9:00, 9:20, 9:40, ... , 6월 3일 17:40분의 데이터가 이미 삽입되어 있다.

2. Reservation에 데이터가 추가 될 때, 트리거를 사용하여 해당 paitents의 code와 datetime을 Paitent_Timeslots에 추가한다. Paitent_Timeslots에는 paitent_code와 datetime이 primary key이므로, 중복 예약을 하려고 하면 트리거에 의해 거절된다.

3. Treatement에 데이터가 추가 될 때, 트리거를 사용하여 해당 doctor의 employee_code와 datetime을 Employee_Timeslots에 추가한다. Employee_Timeslots에는 employee_code와 datetime이 primary key이므로, 이미 다른 treatement나 operation에 참여하고 있는 경우 트리거에 의해 거절된다.

4. Operation_Doctors와 Operation_Nurses에 데이터가 추가 될 때, 트리거를 사용하여 해당 doctor와 nurse의 employee_code와 datetime을 Employee_Timeslots에 추가한다. Employee_Timeslots에는 employee_code와 datetime이 primary key이므로, 이미 다른 treatement나 operation에 참여하고 있는 경우 트리거에 의해 거절된다.