require_relative "../services/compiler/compiler"
require_relative "../errors/compiler/unsupported_language_error"
require_relative "../errors/compiler/language_recognition_error"
require_relative "../errors/compiler/token_error"
require_relative "../errors/compiler/syntax_error"

class CompilationsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_compilation, only: [ :destroy ]

  def create
    begin
      if params[:file].present?
        uploaded_file = params[:file]
        input_text = uploaded_file.original_filename
        output_text = nil

        time = Compiler.time { output_text = Compiler.compile(uploaded_file, from_file: true) }
        input_type = "file"

      elsif params[:code].present?
        input_text = params[:code]
        output_text = nil

        time = Compiler.time { output_text = Compiler.compile(input_text, from_file: false) }
        input_type = "code"

      else
        flash.now[:alert] = "Please provide code or upload a file"
        @compilations = current_user && session[:guest_session] != true ? current_user.compilations.order(created_at: :desc) : []
        return render "pages/home", status: :unprocessable_entity
      end

      unless session[:guest_session]
        @compilation = current_user.compilations.create!(
          input_type: input_type,
          input_text: input_text,
          output_text: output_text
        )
      end

      @pseudocode_output = output_text
      @compilations = current_user && session[:guest_session] != true ? current_user.compilations.order(created_at: :desc) : []
      flash.now[:notice] = "Compilation successful in #{time} seconds!"
      render "pages/home"

    rescue Compiler::UnsupportedLanguageError => e
      flash.now[:alert] = "Unsupported language: #{e.message}"
      @compilations = current_user && session[:guest_session] != true ? current_user.compilations.order(created_at: :desc) : []
      render "pages/home", status: :unprocessable_entity
    rescue Compiler::LanguageRecognitionError => e
      flash.now[:alert] = "Could not recognize language: #{e.message}"
      @compilations = current_user && session[:guest_session] != true ? current_user.compilations.order(created_at: :desc) : []
      render "pages/home", status: :unprocessable_entity
    rescue Compiler::TokenError => e
      flash.now[:alert] = "Token error: #{e.message}"
      @compilations = current_user && session[:guest_session] != true ? current_user.compilations.order(created_at: :desc) : []
      render "pages/home", status: :unprocessable_entity
    rescue ::Compiler::SyntaxError => e
      flash.now[:alert] = "Syntax error: #{e.message}"
      @compilations = current_user && session[:guest_session] != true ? current_user.compilations.order(created_at: :desc) : []
      render "pages/home", status: :unprocessable_entity
    rescue Errno::ENOENT
      flash.now[:alert] = "File upload error. Please try again."
      @compilations = current_user && session[:guest_session] != true ? current_user.compilations.order(created_at: :desc) : []
      render "pages/home", status: :unprocessable_entity
    rescue => e
      flash.now[:alert] = "Compilation error: #{e.message}"
      @compilations = current_user && session[:guest_session] != true ? current_user.compilations.order(created_at: :desc) : []
      render "pages/home", status: :unprocessable_entity
    end
  end

  def destroy
    @compilation.destroy
    redirect_to root_path, notice: "Compilation deleted successfully"
  end

  private

  def authenticate_user!
    redirect_to root_path, alert: "You must log in to compile code" unless logged_in?
  end

  def find_compilation
    @compilation = current_user.compilations.find(params[:id])
  end
end
