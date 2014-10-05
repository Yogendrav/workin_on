class Dashboard::CommentsController < ApplicationController
  def index
    @comments = Event.all.map{|a| a.comments}
  end
  def new
    @comment = Comment.new
    respond_to do |format|
      format.js
    end
  end
  def create
    @event = Event.find(params[:comment][:event_id])
    @comment = @event.comments.build(comment_params)
    @comment = current_admin.comments.build(comment_params)
    @comment.save
  end
  def destroy
    @comment = Comment.find(params[:id])
    @comment.delete
  end
  private
  def comment_params
    params.require(:comment).permit(:comment_box, :event_id, :admin_id)
  end
end
