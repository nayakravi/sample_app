module SessionsHelper

	def sign_in(user)
		cookies.permanent.signed[:remember_token] = [user.id, user.salt]
		session[:current_user_id] = user.id
		self.current_user = user
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		if use_cookie
			@current_user ||= user_from_remember_token
		else
			@current_user ||= user_from_session
		end
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		cookies.delete(:remember_token)
		session[:current_user_id] = nil
		self.current_user = nil
	end

	def current_user?(user)
		user == current_user
	end

    def authenticate
      deny_access unless signed_in?
    end

	def deny_access
		store_location
		redirect_to signin_path, :notice => "Please sign in to access this page."
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		clear_return_to
	end

	private

		def user_from_remember_token
			User.authenticate_with_salt(*remember_token)
		end

		def remember_token
			cookies.signed[:remember_token] || [nil, nil]
		end

		def user_from_session
			user = (session[:current_user_id] == nil) ? nil :
				User.find_by_id(session[:current_user_id])
			return nil if user.nil?
			return user
		end

		def use_cookie
			return true
		end

		def store_location
			session[:return_to] = request.fullpath
		end

		def clear_return_to
			session[:return_to] = nil
		end
end
