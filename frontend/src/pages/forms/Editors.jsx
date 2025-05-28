import React from "react";
import { Helmet } from "react-helmet-async";
import { Card, Container } from "react-bootstrap";

const Editors = () => (
  <React.Fragment>
    <Helmet title="Editors" />
    <Container fluid className="p-0">
      <h1 className="h3 mb-3">Editors</h1>
      <Card>
        <Card.Header>
          <Card.Title>Editors</Card.Title>
          <h6 className="card-subtitle text-muted">
            Rich text editor functionality has been removed.
          </h6>
        </Card.Header>
        <Card.Body>
          <p>Editor functionality will be added later.</p>
        </Card.Body>
      </Card>
    </Container>
  </React.Fragment>
);

export default Editors;