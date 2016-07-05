#include <stdio.h>
#include <sqlca.h>

long SQLCODE;

void tgetline(char line[], int max)
{
    int c, i=0;
    while ((c=getchar()) != '\n' && c != EOF)
        if (i < max) line[i++] = c;
    line[i] = '\0';
}

void sql_error(char *msg)
{
    char err_msg[128];
    size_t buf_len, msg_len;    

    EXEC SQL WHENEVER SQLERROR CONTINUE;
    printf("sqlcode:%d\n",SQLCODE);

    printf("\n%s\n",msg);
    buf_len = sizeof(err_msg);
    sqlglm(err_msg,&buf_len,&msg_len);
    printf("%.*s\n",msg_len,err_msg);

    EXEC SQL ROLLBACK RELEASE;
    exit(1);
}

void do_connect() {
    EXEC SQL BEGIN DECLARE SECTION;
        char username[20];
        char password[20];
        char *tns_name = "cs360";
    EXEC SQL END DECLARE SECTION;

    EXEC SQL WHENEVER SQLERROR do sql_error("Oracle Error");

    printf("ID: ");
    tgetline(username, 19);
    printf("PW: ");
    tgetline(password, 19);

    EXEC SQL CONNECT :username IDENTIFIED BY :password USING :tns_name;
}

void solution1() {
	printf("s20151436 student information:\n");
	printf("---------------------------------------------------------------\n");
	printf("%-29s%-29s%-3s\n", "Professor", "Course Title", "Grade");
	printf("---------------------------------------------------------------\n");
	
	EXEC SQL BEGIN DECLARE SECTION;
        char profName[30];
		char title[30];
		char grade[4];
    EXEC SQL END DECLARE SECTION;
	
	EXEC SQL DECLARE student_cur CURSOR FOR SELECT profName, title, grade FROM enroll, course, professor WHERE enroll.courseID = course.courseID AND course.profID = professor.profID AND enroll.stuID = 's20151436';
	
    EXEC SQL OPEN student_cur; 
    for (;;) {
        EXEC SQL FETCH student_cur INTO :profName, :title, :grade;
        if (sqlca.sqlcode == 1403)
            break;
        printf("%s%s%s\n", profName, title, grade);
    }
    EXEC SQL CLOSE student_cur;
}

void solution2() {
	printf("---------------------------------------------------------------\n");
	printf("%-29s%-4s\n", "title", "ratio of 'A' grades");
	printf("---------------------------------------------------------------\n");
	
	char curID[30]; int ast = 0, cst = 0, first = 1;
	EXEC SQL BEGIN DECLARE SECTION;
		char courseID[30];
		char grade[4];
	EXEC SQL END DECLARE SECTION;
	
	EXEC SQL DECLARE course_cur CURSOR FOR SELECT courseID, grade FROM enroll ORDER BY courseID;

	EXEC SQL OPEN course_cur;
	for (;;) {
		EXEC SQL FETCH course_cur INTO :courseID, :grade;
		if (sqlca.sqlcode == 1403)
            break;
			
		if (strcmp(curID, courseID) != 0) {
			if (first != 1 && (float)ast / cst < 0.3)
				printf("%s%4f\n", curID, (float)ast / cst);
			strcpy(curID, courseID); ast = cst = 0;
		}
		
		if (grade[0] == 'A')
			ast++;
		cst++; first = 0;
	}
	if ((float)ast / cst < 0.3)
		printf("%s%4f\n", courseID, (float)ast / cst);
	EXEC SQL CLOSE course_cur;
}

void solution3() {	
	EXEC SQL BEGIN DECLARE SECTION;
		char icourseID[30], istuID[30];
		char title[30], grade[4];
		char stmt[1000] = "SELECT title, grade FROM enroll, course WHERE enroll.courseID = course.courseID AND enroll.courseID = :icourseID AND enroll.stuID = :istuID FOR UPDATE OF grade";
	EXEC SQL END DECLARE SECTION;
	
	printf("Student ID: "); getchar(); tgetline(istuID, 30);
	printf("Course ID: "); tgetline(icourseID, 30);
	
	printf("---------------------------------------------------------------\n");
	printf("%-29s%-4s\n", "title", "grade");
	printf("---------------------------------------------------------------\n");
	
	EXEC SQL PREPARE SQLquery FROM :stmt;
	EXEC SQL DECLARE update_cur CURSOR FOR SQLquery;
	EXEC SQL OPEN update_cur USING :icourseID, :istuID;
	
	EXEC SQL FETCH update_cur INTO :title, :grade;
	if (sqlca.sqlcode == 1403) {
		printf("No such data\n");
		return;
	}
	if (grade[0] == 'A') {
		EXEC SQL UPDATE enroll SET grade = 'B' WHERE CURRENT OF update_cur;
		grade[0] = 'B';
	} else {
		EXEC SQL UPDATE enroll SET grade = 'A' WHERE CURRENT OF update_cur;
		grade[0] = 'A';
	}
	printf("%s%s\n", title, grade);
	EXEC SQL CLOSE update_cur;
}

void solution4() {
	EXEC SQL BEGIN DECLARE SECTION;
		char result[30];
		char stmt[2000];
	EXEC SQL END DECLARE SECTION;
	
	printf("SQL: "); getchar(); tgetline(stmt, 2000);
	printf("-----------------------------------\n");
	
	EXEC SQL PREPARE SQLquery FROM :stmt;
	EXEC SQL DECLARE cursor CURSOR FOR SQLquery;
	EXEC SQL OPEN cursor;
	for (;;) {
		EXEC SQL FETCH cursor INTO :result;
		if (sqlca.sqlcode == 1403)
            break;
		printf("%s\n", result);
	}
	EXEC SQL CLOSE cursor;
}

int main()
{
    do_connect();

    printf("---------------------------------\n");
    printf("--------CS360 HW3 ESQL/C---------\n");
    printf("---------------------------------\n");
    
    int input;
    for(;;) {
        printf("enter solution number(1~4), quit(5): ");
        scanf("%d", &input);
        if (input == 5) break;
        switch (input) {
            case 1:
                solution1(); break;
            case 2:
                solution2(); break;
            case 3:
                solution3(); break;
            case 4:
                solution4(); break;
            default:
                printf("unknown command: %d", input);
        }
		printf("\n");
    }

    return 0;
}   