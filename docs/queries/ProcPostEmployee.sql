CREATE PROCEDURE ProcPostEmployee
    (		
		@companycode VARCHAR(3),
		@employeecode VARCHAR(7),
		@agencycode VARCHAR(3),
		@lastname VARCHAR(50),
		@firstname VARCHAR(50),
		@mi VARCHAR(1),
		@nickname VARCHAR(20),
		@gender VARCHAR(1),
		@datebirth DATETIME,
		@marstatus VARCHAR(1),
		@noofchildren NUMERIC(1,0),
		@educcode VARCHAR(2),
		@phone VARCHAR(10),
		@cellphone VARCHAR(11),
		@presentaddress VARCHAR(100),
		@permanentaddress VARCHAR(100),
		@course VARCHAR(100),
		@school VARCHAR(100),
		@conperson VARCHAR(50),
		@conrelationship VARCHAR(50),
		@conaddress VARCHAR(50),
		@connumber VARCHAR(50),
		@shiftid NUMERIC(3,0),
		@departmentcode VARCHAR(3),
		@sectioncode VARCHAR(5),
		@teamcode VARCHAR(5),
		@positioncode VARCHAR(5),
		@designationcode VARCHAR(5),
		@contractstatus VARCHAR(1),
		@contracthireddate DATETIME,
		@regularhireddate DATETIME,
		@retireddate DATETIME,
		@createddate DATETIME,
		@updateddate DATETIME,
		@updatedby VARCHAR(7)
    )
AS

BEGIN

	-- declaring variables
	DECLARE @results VARCHAR(255)
	
	-- try catch error
	BEGIN TRY
        IF  (EXISTS(SELECT EmployeeCode FROM Employees WHERE EmployeeCode = @employeecode))
        			
        	BEGIN
        		UPDATE Employees SET AgencyCode = @agencycode, LastName = @lastname, FirstName = @firstname, MI = @mi,
					NickName = @nickname, Gender = @gender, DateBirth = @datebirth, MarStatus = @marstatus, 
					NoOfChildren = @noofchildren, EducCode = @educcode, Phone = @phone, Cellphone = @cellphone, 
					PresentAddress = @presentaddress, PermanentAddress = @permanentaddress, Course = @course, School = @school,
					ConPerson = @conperson, ConRelationship = @conrelationship, ConAddress = @conaddress, ConNumber = @connumber, 
					ShiftID = @shiftid, DepartmentCode = @departmentcode, SectionCode = @sectioncode, TeamCode = @teamcode, 
					PositionCode = @positioncode, DesignationCode = @designationcode, ContractStatus = @contractstatus, 
					ContractHiredDate = @contracthireddate, RegularHiredDate = @regularhireddate, RetiredDate = @retireddate, 
					CreatedDate = @createddate, UpdatedDate = @updateddate, UpdatedBy = @updatedby 
					WHERE EmployeeCode = @employeecode

        						
            	SET @results = 1
            END 
        ELSE
            BEGIN
            
				INSERT INTO Employees(CompanyCode, EmployeeCode, AgencyCode, LastName, FirstName, MI,
					NickName, Gender, DateBirth, MarStatus, NoOfChildren, EducCode, Phone, Cellphone, PresentAddress,
					PermanentAddress, Course, School, ConPerson, ConRelationship, ConAddress, ConNumber, ShiftID,
					DepartmentCode, SectionCode,  TeamCode, PositionCode, DesignationCode, ContractStatus, ContractHiredDate,
					RegularHiredDate, RetiredDate, CreatedDate, UpdatedDate, UpdatedBy)
					VALUES (@companycode, @employeecode, @agencycode, @lastname, @firstname, @mi,
					@nickname, @gender, @datebirth, @marstatus, @noofchildren, @educcode, @phone, @cellphone,
					@presentaddress, @permanentaddress, @course, @school, @conperson, @conrelationship, @conaddress, 
					@connumber, @shiftid, @departmentcode, @sectioncode, @teamcode, @positioncode, @designationcode, 
					@contractstatus, @contracthireddate, @regularhireddate, @retireddate, @createddate, @updateddate, @updatedby)

						
            	SET @results = 0
        	END
 	 END TRY
     
     --catch the error
     BEGIN CATCH
 		SET @results = 404
     END CATCH
     
	 -- return the message of query
	 SELECT @results AS Results
END



GO

