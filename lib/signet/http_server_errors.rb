module Signet

  module HTTPServerErrors

    ERRORS = {
      no_auth:  {
        message: 'No auth parameter was supplied',
        status: :bad_request
      },
      bad_auth: {
        message: 'Authentication failed; check your auth parameter.',
        status: :forbidden
      },
      no_csr:   {
        message: 'No csr parameter was supplied',
        status: :bad_request
      },
      bad_csr:  {
        message: "Couldn't parse that csr parameter; are you sure it's a CSR in PEM format?",
        status: :bad_request
      },
    }
  end
end
