class CompilationsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_compilation, only: [ :destroy ]

  def create
    input_text =
      if params[:code].present?
        params[:code]
      else
        params[:file]&.read
      end

    return redirect_to home_path, alert: "No code provided" if input_text.blank?

    begin
      Compiler.compile_text(input_text)
      output_text = "Pseudocode generated successfully"
    rescue Compiler::LanguageRecognitionError => e
      output_text = "Error: #{e.message}"
    rescue => e
      output_text = "Compilation error: #{e.message}"
    end

    language = detect_language(input_text)

    # Only save for registered users, not guests
    if session[:guest_session]
      redirect_to home_path, notice: "Pseudocode generated! (Guest sessions don't save history)"
    else
      compilation = current_user.compilations.create!(
        input_type: params[:file].present? ? "file" : "text",
        input_text: input_text,
        output_text: output_text,
        language: language
      )

      redirect_to home_path, notice: "Pseudocode generated and saved!"
    end
  end

  def destroy
    @compilation.destroy
    redirect_to home_path, notice: "Compilation deleted!"
  end

  private

  def find_compilation
    @compilation = Compilation.find(params[:id])
    redirect_to home_path, alert: "Unauthorized" unless @compilation.user == current_user
  end

  def detect_language(code)
    # Simple language detection based on syntax
    case code
    when /\bfunction\b|\bconst\b|\blet\b|\bvar\b/
      "JavaScript"
    when /\bdef\b|\bclass\b|\bimport\b/
      "Python"
    when /\bpublic class\b|\bpackage\b/
      "Java"
    when /\bfunc\b|\bpackage\b/
      "Go"
    else
      "Unknown"
    end
  end

  def authenticate_user!
    redirect_to root_path, alert: "You must log in to compile code" unless logged_in?
  end
end
