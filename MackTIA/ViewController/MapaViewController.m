//
//  MapaViewController.m
//  MACK
//
//  Created by Lucas Salton Cardinali on 2/7/14.
//  Copyright (c) 2014 Lucas Salton Cardinali. All rights reserved.
//

#import "MapaViewController.h"
#import "Mapa/MapOverlay.h"
#import "Mapa/MapOverlayView.h"
#import <MapKit/MKMapCamera.h>

@interface MapaViewController ()
@property(nonatomic) MapOverlay * mapOverlay;
@end

@implementation MapaViewController
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        
//        // Custom initialization
//    }
//    return self;
//}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    
    MapOverlay *mapOverlay = (MapOverlay *)overlay;
    MapOverlayView *mapOverlayView = [[MapOverlayView alloc] initWithOverlay:mapOverlay];
    
    return mapOverlayView;
}


-(void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.tabBarItem setImage: [[UIImage imageNamed:@"Mapa"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [self.tabBarItem setSelectedImage: [UIImage imageNamed:@"MapaSelected"]];

    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLLocationAccuracyBest;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    
  //  CLLocation *location = [locationManager location];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(-23.547356, -46.65161);
    
    _mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 360, 360);
    
    
    _mapOverlay = [[MapOverlay alloc] init];
    [_mapView addOverlay:_mapOverlay];
    _mapView.showsUserLocation = YES;
    
    MKMapCamera *newCamera = [[_mapView camera] copy];
     [newCamera setHeading:240.0]; // or newCamera.heading + 90.0 % 360.0
     [_mapView setCamera:newCamera animated:NO];

    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(handleGesture:)];
    tgr.numberOfTapsRequired = 1;
    [_mapView addGestureRecognizer:tgr];
    
    
    CLLocationCoordinate2D coordinate1;
    coordinate1.latitude = -23.547340;
    coordinate1.longitude = -46.651470;
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Faculdade de Computação";
    point.subtitle = @"Prédio 31";
    [self.mapView addAnnotation:point];
   
    
    coordinate1.latitude = -23.547206;
    coordinate1.longitude = -46.651631;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"CEFT - Centro de Educação, Filosofia e Teologia";
    point.subtitle = @"Prédio 25";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.547535;
    coordinate1.longitude = -46.651233;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Laboratórios de Informática";
    point.subtitle = @"Prédio 33";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.547614;
    coordinate1.longitude = -46.651000;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Laboratório da Escola de Engenharia";
    point.subtitle = @"Prédio 37";
    [self.mapView addAnnotation:point];
    
    
    coordinate1.latitude = -23.547609;
    coordinate1.longitude = -46.650824;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Laboratórios CCBS / Cozinha Experimental";
    point.subtitle = @"Prédio 38 - Ed. Rev. Amantino Adorno Vassão";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.547216;
    coordinate1.longitude = -46.650182;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Alfabetização e Educação de Jovens e Adultos";
    point.subtitle = @"Prédio 139";
    [self.mapView addAnnotation:point];
    
    
    coordinate1.latitude = -23.547328;
    coordinate1.longitude = -46.649961;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Graduação / Pós-Graduação";
    point.subtitle = @"Prédio 117 - Ed. Baronesa Maria Antônia Da Silva Ramos";
    [self.mapView addAnnotation:point];
    
    
    coordinate1.latitude = -23.547609;
    coordinate1.longitude = -46.650824;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Pós-Graduação e Administração Geral";
    point.subtitle = @"Prédio 41 - Ed. João Calvino";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.548001;
    coordinate1.longitude = -46.650320;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Pós-Graduação e Administração Geral";
    point.subtitle = @"Prédio 41 - Ed. João Calvino";
    [self.mapView addAnnotation:point];
    
    
    coordinate1.latitude = -23.547926;
    coordinate1.longitude = -46.650868;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Laboratório de Gravura";
    point.subtitle = @"Prédio 40 - Ed. Antônio Bandeira Trajano";
    [self.mapView addAnnotation:point];
    
    
    
    coordinate1.latitude = -23.547999;
    coordinate1.longitude = -46.651024;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Almoxarifado/Serviços de Apoio/Manutenção";
    point.subtitle = @"Prédio 35";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.547609;
    coordinate1.longitude = -46.650824;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Biotério Animal";
    point.subtitle = @"Prédio 34";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.548721;
    coordinate1.longitude = -46.650691;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Juizado Especial Cível";
    point.subtitle = @"Prédio 993";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.548558;
    coordinate1.longitude = -46.649897;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Pós Graduação latu-sensu";
    point.subtitle = @"Prédio 847";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.547580;
    coordinate1.longitude = -46.651522;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Laboratórios da Escola de Engenharia";
    point.subtitle = @"Prédio 30 - Ed. Paulo Costa Lenz César";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.547680;
    coordinate1.longitude = -46.651778;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Quadras Cobertas";
    point.subtitle = @"Prédio 29";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.548558;
    coordinate1.longitude = -46.649897;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Pós Graduação latu-sensu";
    point.subtitle = @"Prédio 847";
    [self.mapView addAnnotation:point];
    
    
    coordinate1.latitude = -23.548004;
    coordinate1.longitude = -46.652184;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Quadras";
    point.subtitle = @"";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.548378;
    coordinate1.longitude = -46.651856;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Centro de Ciências Biológicas e da Saúde";
    point.subtitle = @"Prédio 50";
    [self.mapView addAnnotation:point];
    
    
    coordinate1.latitude = -23.548402;
    coordinate1.longitude = -46.652485;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Centro de Comunicação e Letras";
    point.subtitle = @"Prédio 49";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.548125;
    coordinate1.longitude = -46.652571;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Colégio P. Mackenzie - Ed. Básica";
    point.subtitle = @"Prédio 48";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.548448;
    coordinate1.longitude = -46.652873;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Diretórios";
    point.subtitle = @"Prédio 85";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.548008;
    coordinate1.longitude = -46.653199;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Centro de Comunicação e Letras";
    point.subtitle = @"Prédio 143";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.547708;
    coordinate1.longitude = -46.653341;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Clínicas CCBS";
    point.subtitle = @"Prédio 181";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.547771;
    coordinate1.longitude = -46.652841;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Colégio Presbiteriano Mackenzie";
    point.subtitle = @"Prédio 46";
    [self.mapView addAnnotation:point];
    
    
    
    coordinate1.latitude = -23.547437;
    coordinate1.longitude = -46.652371;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Centro de Ciências Sociais Aplicadas";
    point.subtitle = @"Prédio 45";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.547256;
    coordinate1.longitude = -46.653028;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Colégio Presbiteriano Mackenzie";
    point.subtitle = @"Prédio 44";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.547077;
    coordinate1.longitude = -46.653354;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Marcenaria";
    point.subtitle = @"Prédio 43";
    [self.mapView addAnnotation:point];
    
    
    coordinate1.latitude = -23.547075;
    coordinate1.longitude = -46.652052;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Ginásio de Esportes";
    point.subtitle = @"Prédio 20";
    [self.mapView addAnnotation:point];
    
    
    coordinate1.latitude = -23.546554;
    coordinate1.longitude = -46.651562;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Engenharia";
    point.subtitle = @"Prédio 6";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.546343;
    coordinate1.longitude = -46.651373;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Engenharia";
    point.subtitle = @"Prédio 5";
    [self.mapView addAnnotation:point];
    
    
    coordinate1.latitude = -23.546953;
    coordinate1.longitude = -46.652379;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Auditorio Ruy Barbosa / Praça de Alimentação / Ensino Médio";
    point.subtitle = @"Prédio 19";
    [self.mapView addAnnotation:point];
    
    
    coordinate1.latitude = -23.546997;
    coordinate1.longitude = -46.652963;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Colégio Presbiteriano Mackenzie";
    point.subtitle = @"Prédio 18";
    [self.mapView addAnnotation:point];
    
    
    coordinate1.latitude = -23.546684;
    coordinate1.longitude = -46.652999;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Matricula";
    point.subtitle = @"Prédio 13";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.546455;
    coordinate1.longitude = -46.651768;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Diretórios / Gráfica";
    point.subtitle = @"Prédio 7";
    [self.mapView addAnnotation:point];
    
    
    coordinate1.latitude = -23.546501;
    coordinate1.longitude = -46.651993;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Laboratórios de Informática";
    point.subtitle = @"Prédio 10";
    [self.mapView addAnnotation:point];
    
    
    coordinate1.latitude = -23.546211;
    coordinate1.longitude = -46.651606;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Engenharia";
    point.subtitle = @"Prédio 4";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.546039;
    coordinate1.longitude = -46.651819;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Direito";
    point.subtitle = @"Prédio 3";
    [self.mapView addAnnotation:point];
    
    
    
    coordinate1.latitude = -23.545902;
    coordinate1.longitude = -46.651999;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Biblioteca Central";
    point.subtitle = @"Prédio 2";
    [self.mapView addAnnotation:point];
    
    
    coordinate1.latitude = -23.545791;
    coordinate1.longitude = -46.652133;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Centro Histórico";
    point.subtitle = @"Prédio 1";
    [self.mapView addAnnotation:point];
    
    
    coordinate1.latitude = -23.546344;
    coordinate1.longitude = -46.652430;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Arquitetura e Design";
    point.subtitle = @"Prédio 9";
    [self.mapView addAnnotation:point];
    
    
    coordinate1.latitude = -23.546497;
    coordinate1.longitude = -46.652600;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Capela";
    point.subtitle = @"Prédio 11";
    [self.mapView addAnnotation:point];
    
    
    coordinate1.latitude = -23.546495;
    coordinate1.longitude = -46.652865;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Central de Atendimento";
    point.subtitle = @"Prédio 12";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.547311;
    coordinate1.longitude = -46.651852;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Laboratórios CCBS, CCL e Engenharia";
    point.subtitle = @"Prédio 28";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.546919;
    coordinate1.longitude = -46.651490;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Engenharia / Direito";
    point.subtitle = @"Prédio 24";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.546721;
    coordinate1.longitude = -46.651337;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Enfermaria";
    point.subtitle = @"Prédio 23";
    [self.mapView addAnnotation:point];
    
    
    
    
    
    coordinate1.latitude = -23.546843;
    coordinate1.longitude = -46.652710;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Colégio Presbiteriano Mackenzie";
    point.subtitle = @"Prédio 17";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.546804;
    coordinate1.longitude = -46.652780;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Colégio Presbiteriano Mackenzie";
    point.subtitle = @"Prédio 16";
    [self.mapView addAnnotation:point];
    
    
    coordinate1.latitude = -23.546781;
    coordinate1.longitude = -46.652857;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Atendimento Financeiro";
    point.subtitle = @"Prédio 15";
    [self.mapView addAnnotation:point];
    
    coordinate1.latitude = -23.546729;
    coordinate1.longitude = -46.652921;
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate1;
    point.title = @"Secretaria Geral";
    point.subtitle = @"Prédio 14";
    [self.mapView addAnnotation:point];
    
    
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"aviso_mapa"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                        message:@"Não use sua localização no mapa como referência direta pois o GPS é impreciso"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"aviso_mapa"];
    }
    
    
    
}






- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
    CLLocationCoordinate2D coordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    
    NSLog(@"latitude  %f longitude %f",coordinate.latitude,coordinate.longitude);
    
    
}


@end