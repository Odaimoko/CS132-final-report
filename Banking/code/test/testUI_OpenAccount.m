classdef testUI_OpenAccount < matlab.uitest.TestCase
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
        function test_OpenAccount_normal(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
            
        end
        function test_OpenAccount_duplicate(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
        end
        function test_OpenAccount_missPwd(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.press(testCase.App.Confirm_open_account);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, 'Password cannot be emtpy');
        end
        function test_OpenAccount_missAccount(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.PW_Input, '123');
            testCase.press(testCase.App.Confirm_open_account);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, 'Id cannot be emtpy');
        end
%         function test_OpenAccount_minusAccount(testCase)
%             testCase.press(testCase.App.open_account);
%             testCase.type(testCase.App.Identity_Input, -123);
%             testCase.type(testCase.App.PW_Input, '123');
%             testCase.press(testCase.App.Confirm_open_account);
%             testCase.verifyEqual(testCase.App.Message_Feedback.Text, 'Account added Failed');
%         end
%         function test_OpenAccount_minusPwd(testCase)
%             testCase.press(testCase.App.open_account);
%             testCase.type(testCase.App.Identity_Input, 123);
%             testCase.type(testCase.App.PW_Input, '-123');
%             testCase.press(testCase.App.Confirm_open_account);
%             testCase.verifyEqual(testCase.App.Message_Feedback.Text, 'Account added Failed');
%         end
        
        
        
    end
    
end