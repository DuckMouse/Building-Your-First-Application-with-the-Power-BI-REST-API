import { Component, OnInit  } from '@angular/core';
import { PowerbiService } from './services/powerbi.service';
import { Report } from './models/report.model';
import * as pbi from 'powerbi-client';
import { EmbedInfo } from './models/embed-info.model';
@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit {
  title = 'power-bi-embedding-fe';
  myReports: Report[] = [];
  private pbiContainerElement: HTMLElement;
  constructor(private powerbiService: PowerbiService) {}
  ngOnInit() {
    this.pbiContainerElement = <HTMLElement>(
      document.getElementById('reportContainer')
    );
    this.loadAllReports();
  }
  loadAllReports() {
    this.powerbiService.getReports().subscribe(reports => {
       this.myReports = reports;
       console.log(this.myReports);
    });
  }
  embedReport(reportId: string) {
    const powerbi = new pbi.service.Service(
      pbi.factories.hpmFactory,
      pbi.factories.wpmpFactory,
      pbi.factories.routerFactory
    );
    this.powerbiService.getReportById(reportId).subscribe(data => {
      const embedConfig = this.buildEmbedConfig(data);
      powerbi.reset(this.pbiContainerElement);
      powerbi.embed(this.pbiContainerElement, embedConfig);
    });
  }
  private buildEmbedConfig(data: EmbedInfo) {
    return <pbi.IEmbedConfiguration>{
      type: 'report',
      tokenType: pbi.models.TokenType.Embed,
      accessToken: data.EmbedToken.Token,
      embedUrl: data.EmbedUrl,
      id: data.ReportId,
      settings: {
        filterPaneEnabled: false,
        navContentPaneEnabled: false
      }
    };
  }
}
