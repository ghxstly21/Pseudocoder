require_relative "../services/compiler/compiler"
require_relative "../errors/UnsupportedLanguageError"
require_relative "../errors/LanguageRecognitionError"
require_relative "../errors/TokenError"
require_relative "../errors/SyntaxError"

class CompilationsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_compilation, only: [ :destroy ]

  def create
    begin
      if params[:file].present?
        uploaded_file = params[:file]
        file_path = uploaded_file
        output_text = Compiler.compile(file_path.to_s)
        input_type = "file"

      elsif params[:code].present?
        input_text = params[:code]
        output_text = nil

        time = Compiler.time { output_text = Compiler.compile(input_text, from_file: false)}
        input_type = "code"
      else
        redirect_to root_path, alert: "Please provide code or upload a file" and return
      end

      unless session[:guest_session]
        @compilation = current_user.compilations.create!(
          input_type: input_type,
          input_text: input_text,
          output_text: output_text,
          output_time: time,
        )
      end

      flash[:notice] = "Compilation successful in #{time} seconds!"
      flash[:pseudocode_output] = output_text
      redirect_to root_path

    rescue Compiler::UnsupportedLanguageError => e
      redirect_to root_path, alert: "Unsupported language: #{e.message}"
    rescue Compiler::LanguageRecognitionError => e
      redirect_to root_path, alert: "Could not recognize language: #{e.message}"
    rescue Compiler::TokenError => e
      redirect_to root_path, alert: "Token error: #{e.message}"
    rescue Compiler::SyntaxError => e
      redirect_to root_path, alert: "Syntax error: #{e.message}"
    rescue => e
      redirect_to root_path, alert: "Compilation error: #{e.message}"
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
