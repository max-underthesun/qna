class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  def index
    @question = Question.find(params[:question_id])
    @answers = @question.answers
    respond_with @answers, each_serializer: AnswersSerializer
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer
  end

  # def create
  #   @question = current_resource_owner.questions.create(question_params)
  #   respond_with @question, serializer: QuestionShowSerializer
  # end

  # private

  # def question_params
  #   params.require(:question).permit(:title, :body)
  # end
end
