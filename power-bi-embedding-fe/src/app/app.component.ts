import { Component, OnInit  } from '@angular/core';
import { PowerbiService } from './services/powerbi.service';
import { Report } from './models/report.model';
@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit {
  title = 'power-bi-embedding-fe';
  myReports: Report[] = [];
  constructor(private powerbiService: PowerbiService) {}
  ngOnInit() {
    this.loadAllReports();
  }
  loadAllReports() {
    this.powerbiService.getReports().subscribe(reports => {
       this.myReports = reports;
       console.log(this.myReports);
    });
  }
}
