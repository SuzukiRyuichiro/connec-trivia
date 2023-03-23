// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application";

import AddFriendshipController from "./add_friendship_controller";
application.register("add-friendship", AddFriendshipController);

import CorrectAnswersController from "./correct_answers_controller";
application.register("correct-answers", CorrectAnswersController);

import HelloController from "./hello_controller";
application.register("hello", HelloController);

import HighlightAnswersController from "./highlight_answers_controller";
application.register("highlight-answers", HighlightAnswersController);
