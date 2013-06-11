module Signet

  module HTTPServerErrors

    class AuthenticationError < Exception; end

    ERRORS = {
      no_auth:  {
        class: ArgumentError,
        message: 'No auth parameter was supplied',
        status: :bad_request
      },
      bad_auth: {
        class: AuthenticationError,
        message: 'Authentication failed; check your auth parameter.',
        status: :forbidden
      },
      no_csr:   {
        class: ArgumentError,
        message: 'No csr parameter was supplied',
        status: :bad_request
      },
      bad_csr:  {
        class: ArgumentError,
        message: "Couldn't parse that csr parameter; are you sure it's a CSR in PEM format?",
        status: :bad_request
      },
    }
  end
end
