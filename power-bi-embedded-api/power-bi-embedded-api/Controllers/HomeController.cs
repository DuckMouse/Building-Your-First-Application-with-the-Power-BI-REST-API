using Microsoft.Rest;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using System.Threading.Tasks;
using System.Web.Mvc;
using power_bi_embedded_api.Models;
using System;
using Microsoft.PowerBI.Api.V2;

namespace power_bi_embedded_api.Controllers
{
    public class HomeController : Controller
    {
        private PowerbiSettings _powerbiSettings = new PowerbiSettings();
        public ActionResult Index()
        {
            ViewBag.Title = "Home Page";

            return View();
        }
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
        public async Task<ActionResult> GetReports(string workspaceId)
        {
            if (string.IsNullOrWhiteSpace(workspaceId))
            {
                workspaceId = _powerbiSettings.WorkspaceId;
            }
            try
            {
                TokenCredentials tokenCredentials = await CreateCredentials();
                if (tokenCredentials == null)
                {
                    var error = "Authentication Failed";
                    return Json(error, JsonRequestBehavior.AllowGet);
                }
                using (var client = new PowerBIClient(new Uri(_powerbiSettings.ApiUrl), tokenCredentials))
                {
                    var reports = await client.Reports.GetReportsInGroupAsync(workspaceId);
                    return Json(reports.Value, JsonRequestBehavior.AllowGet);
                }
            }
             catch (Exception ex)
            {
                return Json(ex.Message, JsonRequestBehavior.AllowGet);
            }
        }

    }
}
