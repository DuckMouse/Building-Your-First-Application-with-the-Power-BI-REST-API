using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.PowerBI.Api.V2.Models;
namespace power_bi_embedded_api.Models
{
    [Serializable]
    public class EmbedConfig
    {
        public string Id { get; set; }

        public string EmbedUrl { get; set; }

        public EmbedToken EmbedToken { get; set; }

        public string ErrorMessage { get; internal set; }
    }
}