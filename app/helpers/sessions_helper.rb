module SessionsHelper

	def sign_in(user)
		if use_cookie
			cookies.permanent.signed[:remember_token] = [user.id, user.salt]
		else
			session[:current_user_id] = user.id
		end

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
		if use_cookie
			cookies.delete(:remember_token)
		else
			session[:current_user_id] = nil
		end
		
		self.current_user = nil
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
end
