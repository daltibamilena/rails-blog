class ApplicationController < ActionController::Base

def index
  @posts = Post.all
   respond_to do |format|
        format.html { render template: "application/index", locals: {posts: @posts} }
        format.json { render json: posts, status: :ok }
      end
end

end
