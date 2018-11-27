using Microsoft.Rest;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using System.Threading.Tasks;
using System.Web.Mvc;
using power_bi_embedded_api.Models;

namespace power_bi_embedded_api.Controllers
{
    public class HomeController : Controller
    {
        private PowerbiSettings _powerbiSettings = new PowerbiSettings();
        private async Task<AuthenticationResult> Authenticate()
        {
            // Create a user password credentials.
            var credential = new UserPasswordCredential(_powerbiSettings.Username, _powerbiSettings.Password);
            // Authenticate using created credentials
            var authenticationContext = new AuthenticationContext(_powerbiSettings.AuthorityUrl);
            var authenticationResult =
               await authenticationContext.AcquireTokenAsync(_powerbiSettings.ResourceUrl, "ApplicationId", credential);
            return authenticationResult;
        }
        private async Task<TokenCredentials> CreateCredentials()
        {
            AuthenticationResult authenticationResult = await Authenticate();
            if (authenticationResult == null)
            {
                return null;
            }
            TokenCredentials tokenCredentials = new TokenCredentials(authenticationResult.AccessToken, "Bearer");
            return tokenCredentials;
        }

        public ActionResult Index()
        {
            ViewBag.Title = "Home Page";

            return View();
        }
    }
}
