import { TestBed } from '@angular/core/testing';

import { PowerbiService } from './powerbi.service';

describe('PowerbiService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: PowerbiService = TestBed.get(PowerbiService);
    expect(service).toBeTruthy();
  });
});
