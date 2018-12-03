import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { EmbedInfo } from '../models/embed-info.model';
import { Report } from '../models/report.model';

@Injectable({
  providedIn: 'root'
})
export class PowerbiService {
  constructor(private http: HttpClient) {}
  getReports() {
    return this.http.get<Report[]>('http://localhost:63981/home/getreports');
  }

  getReportById(id: string) {
    return this.http.get<EmbedInfo>(`http://localhost:63981/home/embedreport?reportId=${id}`);
  }
}
