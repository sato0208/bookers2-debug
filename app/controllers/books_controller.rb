class BooksController < ApplicationController
  # ログイン済ユーザーのみにアクセスを許可する
  before_action :authenticate_user!
  # カレントユーザーだけしかedit,update,destroyアクションは使えない。
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  def show
    @user = User.find(params[:id])
    @book = Book.new
  	@set_book = Book.find(params[:id])
  end

  def index
    @book = Book.new
  	@books = Book.all #一覧表示するためにBookモデルの情報を全てくださいのall
  end

  def create
  	@book = Book.new(book_params) #Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
    @book.user_id = current_user.id
  	if @book.save #入力されたデータをdbに保存する。
  		redirect_to @book, notice: "successfully created book!"#保存された場合の移動先を指定。
  	else
  		@books = Book.all
  		render :index
  	end
  end

  def edit
  	@book = Book.find(params[:id])
  end

  def update
  	@book = Book.find(params[:id])
  	if @book.update(book_params)
  		redirect_to @book, notice: "successfully updated book!"
  	else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
  		render :edit
  	end
  end

  def destroy
  	@book = Book.find(params[:id])
  	@book.destroy
  	redirect_to books_path, notice: "successfully delete book!"
  end

  private

    # ※カレントユーザー以外は直接リンクを入力しても編集ページにいけないようにする
  def ensure_correct_user
    @book = Book.find(params[:id])
    # ※カレントユーザーIDがbook.user_idと同じでない場合はbooks_pathへ飛ばす
    if current_user.id != @book.user_id
      flash[:notice] = "ページにアクセスする権限がありません"
      redirect_to(books_path)
    end
  end

  def book_params
  	params.require(:book).permit(:title,:body)
  end

end
