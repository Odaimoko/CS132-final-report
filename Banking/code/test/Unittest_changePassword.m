classdef  testUI_changePassword< matlab.uitest.TestCase
    properties
        App
        
    end
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            addpath('..\src');
            addpath('..\src\datastructure');
            addpath('..\ui');
            testCase.App = UI_Clerk_exported;

            testCase.addTeardown(@delete,testCase.App);
            
        end
    end
    methods (Test)
        function test_Transfer_normal(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            id = card_id;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
 

            testCase.press(testCase.App.change_password);
            testCase.type(testCase.App.Account_Input, id);
            testCase.type(testCase.App.PW_Input, '123');
            testCase.type(testCase.App.New_PW_Input, '456');
            
            testCase.press(testCase.App.Confirm_change_pw);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Password changed successfully.']);
        end
        
        
        
    end
    
end